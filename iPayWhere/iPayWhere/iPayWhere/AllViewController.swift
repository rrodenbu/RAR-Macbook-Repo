//
//  AllViewController.swift
//  iPayWhere
//
//  Created by Riley Rodenburg on 12/17/16.
//  Copyright © 2016 buddhabuddha. All rights reserved.
//

import UIKit
import MapKit
import CloudKit
import GoogleMobileAds

// Displays the location of all the Apple Pay Banks on a Map
class AllViewController: UIViewController,UIGestureRecognizerDelegate, CLLocationManagerDelegate {
    
    var allCompaniesArray:[String] = []
    var allCompanyNames:[String] = []
    
    var foodDone = false
    var shopDone = false
    var gasDone = false
    
    var selectedPin: MKPlacemark?
    var oldAnnotations = [MKPointAnnotation]()
    
    @IBOutlet var bannerView: GADBannerView!

    var search = MKLocalSearch(request: MKLocalSearchRequest())
    
    let locationManager = CLLocationManager()
    var matchingItems: [MKMapItem] = []
    var annotations = [MKPointAnnotation]()
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.removeAnnotations(self.mapView.annotations)
        for shop in allCompaniesArray {
            var clean = shop.replacingOccurrences(of: "’", with: "'", options: .regularExpression, range: nil)
            clean = clean.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            allCompanyNames.append(clean)
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        //Loading advertisement
        self.bannerView.adUnitID = "ca-app-pub-6433292677244522/6849368295"
        self.bannerView.rootViewController = self
        let request: GADRequest = GADRequest()
        self.bannerView.load(request)
        //mapView.addSubview(bannerView)
        
        //detecting drag
        // add pan gesture to detect when the map moves
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragMap(_:)))
        
        // make your class the delegate of the pan gesture
        panGesture.delegate = self
        
        // add the gesture to the mapView
        mapView.addGestureRecognizer(panGesture)
        
        
    }
    
    
    func getDirections(){
        let mapItem = MKMapItem(placemark: selectedPin!)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        //mapItem.openInMaps(launchOptions: launchOptions)
    }

}




/*
 Customizing the pins and their annotations to include name and address
 */
extension AllViewController {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func didDragMap(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            if(self.foodDone && self.gasDone && self.shopDone) {
                print(search.isSearching)
                //search.cancel()
                print("DRAGGED>>>>")
                //oldAnnotations = annotations
                //self.mapView.removeAnnotations(self.mapView.annotations)
                if(search.isSearching == false){
                    print("HERE")
                    getLocations()
                }
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(0.09, 0.09)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        if(self.foodDone && self.gasDone && self.shopDone) {
            print("RELOADED")
        } else {
            getCompanies()
        }
        
        //getLocations()
    }
    
    
    func getCompanies() {
        print("getting companies")
        let pred = NSPredicate(value: true)
        
        let queryFood = CKQuery(recordType: "Restaurants", predicate: pred)
        let queryShop = CKQuery(recordType: "Stores", predicate: pred)
        let queryGas = CKQuery(recordType: "Gas", predicate: pred)
        
        let operationFood = CKQueryOperation(query: queryFood)
        operationFood.desiredKeys = ["Name"]
        operationFood.resultsLimit = 5000;
        
        let operationShop = CKQueryOperation(query: queryShop)
        operationShop.desiredKeys = ["Name"]
        operationShop.resultsLimit = 5000;
        
        let operationGas = CKQueryOperation(query: queryGas)
        operationGas.desiredKeys = ["Name"]
        operationGas.resultsLimit = 5000;
        
        operationFood.recordFetchedBlock = { record in
            //print("getting food")
            let name = record.object(forKey: "Name") as? String
            var clean = name?.replacingOccurrences(of: "’", with: "'", options: .regularExpression, range: nil)
            clean = clean?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //print(clean!)
            if(clean != nil) {
                self.allCompanyNames.append(clean!)
            }
            //self.add(clean!)
            
        }
        
        operationFood.queryCompletionBlock = { [unowned self] (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self.foodDone = true
                    print("FOOD DONE.")
                    if(self.gasDone && self.shopDone) {
                        print("FOOD: getting locations")
                        self.getLocations()
                    }
                } else {
                    print("ERROR FOOD")
                    //print(error)
                    return
                }
            }
        }

        operationShop.recordFetchedBlock = { record in
            //print("getting shops")
            let name = record.object(forKey: "Name") as? String
            var clean = name?.replacingOccurrences(of: "’", with: "'", options: .regularExpression, range: nil)
            clean = clean?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //print(clean!)
            if(clean != nil) {
                self.allCompanyNames.append(clean!)
            }
            //self.add(clean!)
        }
        
        operationShop.queryCompletionBlock = { [unowned self] (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self.shopDone = true
                    print("SHOP DONE.")
                    if(self.gasDone && self.foodDone) {
                        print("SHOP: getting locations")
                        
                        self.getLocations()
                    }
                } else {
                    print("ERROR SHOP")
                    //print(error)
                    return
                }
            }
        }
        
        operationGas.recordFetchedBlock = { record in
            print("getting gas")
            let name = record.object(forKey: "Name") as? String
            var clean = name?.replacingOccurrences(of: "’", with: "'", options: .regularExpression, range: nil)
            clean = clean?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            //print(clean!)
            if(clean != nil) {
                self.allCompanyNames.append(clean!)
            }
            //self.add(clean!)
            
        }
        
        operationGas.queryCompletionBlock = { [unowned self] (cursor, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self.gasDone = true
                    print("GAS DONE.")
                    if(self.shopDone && self.foodDone) {
                        print("GAS: getting locations")
                        self.getLocations()
                    }
                } else {
                    print("ERROR GAS")
                    //print(error)
                    return
                }
            }
        }
        /*
         operation.queryCompletionBlock = { [unowned self] (cursor, error) in
         DispatchQueue.main.async {
         if error == nil {
         self.foodsArray = newFoods
         self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
         self.tableView.reloadData()
         } else {
         let ac = UIAlertController(title: "Fetch failed", message: "There was a problem fetching the list of shops; please try again: \(error!.localizedDescription)", preferredStyle: .alert)
         ac.addAction(UIAlertAction(title: "OK", style: .default))
         self.present(ac, animated: true)
         }
         }
         self.activityIndicatorView.stopAnimating()
         }*/
        CKContainer.default().publicCloudDatabase.add(operationFood)
        CKContainer.default().publicCloudDatabase.add(operationShop)
        CKContainer.default().publicCloudDatabase.add(operationGas)
    }
    
    /*func add(_ company: String) {
        
        let request = MKLocalSearchRequest()
        let keywords = ["restaurants", "fast food", "grocery", "pastry", "bakery", "shopping", "apparel", "convenience"]
        
        for keyword in keywords {
            print(keyword)
            request.naturalLanguageQuery = keyword
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            //print(allFoodNames)
            search.start { response, _ in
                guard let response = response else {
                    return
                }
                for item in response.mapItems {
                    print(item.name! as String)
                    
                    let businessName = item.name! as String
                    //print(self.allFoodNames.contains(businessName))
                    if(self.allCompanyNames.contains(businessName)){
                        self.matchingItems.append(item)
                        self.createAnnotations(item)
                    }
                }
                self.mapView.addAnnotations(self.annotations)
            }
        }
        
        /*let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = company
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        //print(allFoodNames)
        search.start { (response, error) in
            if(error != nil) {
                print(error)
                return
            }
            for item in (response?.mapItems)! {
                //print(item.name! as String)
                
                let businessName = item.name! as String
                //print(self.allFoodNames.contains(businessName))
                if(self.allCompanyNames.contains(businessName)){
                    self.matchingItems.append(item)
                    self.createAnnotations(item)
                }
            }
            self.mapView.addAnnotations(self.annotations)
        }*/
        /*
        search.start { response, _ in
            guard let response = response else {
                p
            }
            for item in response.mapItems {
                //print(item.name! as String)
                
                let businessName = item.name! as String
                //print(self.allFoodNames.contains(businessName))
                if(self.allCompanyNames.contains(businessName)){
                    self.matchingItems.append(item)
                    self.createAnnotations(item)
                }
            }
            self.mapView.addAnnotations(self.annotations)
        }*/
    }*/
    
    func getLocations() {
        let request = MKLocalSearchRequest()
        let keywords = ["Restaurants", "Fast Food", "Grocery", "Sandwiches", "Pastry", "Bakery", "Toy Store", "convenience", "Fashion", "Women's Clothing", "Men's Clothing", "Shopping"]
        print("GETTING LOCATION")
        for keyword in keywords {
            request.naturalLanguageQuery = keyword
            request.region = mapView.region
            search = MKLocalSearch(request: request)
            //print(allFoodNames)
            search.start(completionHandler: { (response, error) in
                if(error != nil) {
                    print("ERROR TOO MUCH.")
                    //self.annotations = self.oldAnnotations
                    //self.mapView.addAnnotations(self.annotations)
                    print(error)
                    self.search.cancel()
                    return
                }
                for item in (response?.mapItems)! {
                    //print(item.name! as String)
                    
                    let businessName = item.name! as String
                    //print(self.allFoodNames.contains(businessName))
                    if(self.allCompanyNames.contains(businessName)){
                        print(businessName)
                        //self.matchingItems.append(item)
                        self.createAnnotations(item)
                    }
                }
                self.mapView.addAnnotations(self.annotations)

            })
            print(search.isSearching)

        }
        /*let request = MKLocalSearchRequest()
        print("####################################")
        //print(allCompanyNames)
        let keywords = allCompanyNames
        
        for keyword in keywords {
            //print(keyword)
            request.naturalLanguageQuery = keyword
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            //print(allFoodNames)
            search.start(completionHandler: { (response, error) in
                if(error != nil) {
                    print(error)
                    return
                }
                for item in (response?.mapItems)! {
                    //print(item.name! as String)
                    
                    let businessName = item.name! as String
                    //print(self.allFoodNames.contains(businessName))
                    if(self.allCompanyNames.contains(businessName)){
                        self.matchingItems.append(item)
                        self.createAnnotations(item)
                        self.mapView.addAnnotations(self.annotations)
                    }
                }
                
            })
            /*
            search.start { response, _ in
                guard let response = response else {
                    return
                }
                for item in response.mapItems {
                    //print(item.name! as String)
                    
                    let businessName = item.name! as String
                    //print(self.allFoodNames.contains(businessName))
                    if(self.allCompanyNames.contains(businessName)){
                        self.matchingItems.append(item)
                        self.createAnnotations(item)
                        self.mapView.addAnnotations(self.annotations)
                    }
                }
                
            }*/
        }*/
        
    }
    /*
     func getLocations() {
     for shop in allShopsArray {
     addPinToMap(shop.name)
     print(shop.name)
     }
     
     }*/
    
    func addPinToMap(_ shopName: String) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = shopName
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            for item in response.mapItems {
                let businessName = item.name! as String
                if(self.allCompanyNames.contains(businessName)){
                    self.matchingItems.append(item)
                    self.createAnnotations(item)
                }
            }
            self.mapView.addAnnotations(self.annotations)
        }
    }
    
    func createAnnotations(_ item: MKMapItem) {
        let latitude = item.placemark.coordinate.latitude
        let longitude = item.placemark.coordinate.longitude
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let name = item.name!
        selectedPin = item.placemark
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(name)"
        annotation.subtitle = parseAddress(selectedPin!)
        annotations.append(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR LOCATION MANAGER")
        print("error:: \(error)")
    }
}

/*
 For the directions button to annotations (clicked pin) on map
 */
extension AllShopsViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        if annotation is MKUserLocation {
            
            //return nil so map view draws "blue dot" for standard user location
            return nil
            
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        
        // Add direction button to annotation when a pin is clicked
        pinView?.canShowCallout = true //Allows the annotation to have button
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: UIControlState())
        button.addTarget(self, action: #selector(AllShopsViewController.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
    
    func mapView(_ mapView: MKMapView!, annotationView view: MKAnnotationView!,
                 calloutAccessoryControlTapped control: UIControl!) {
        print("HERE WE ARE !")
        let selectedLoc = view.annotation
        print(selectedLoc?.title)
        
        //println("Annotation '\(selectedLoc.title!)' has been selected")
        
        //let mapItem = MKMapItem(placemark: selectedPin!)
        //print("#######################")
        //print(mapItem.name)
        //let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        //mapItem.openInMaps(launchOptions: launchOptions)
        
        
        //let currentLocMapItem = MKMapItem.forCurrentLocation()
        
        let selectedPlacemark = MKPlacemark(coordinate: (selectedLoc?.coordinate)!, addressDictionary: nil)
        let selectedMapItem = MKMapItem(placemark: selectedPlacemark)
        let mapItem = MKMapItem(placemark: selectedPlacemark)
        mapItem.name = (selectedLoc?.title)!
        print(mapItem.name)
        print(mapItem.placemark)
        //let mapItems = [selectedMapItem, currentLocMapItem]
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions:launchOptions)
    }
}

