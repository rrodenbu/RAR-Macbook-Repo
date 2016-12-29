//
//  AllFoodsViewController.swift
//  iPayWhere
//
//  Created by Riley Rodenburg on 9/4/16.
//  Copyright © 2016 buddhabuddha. All rights reserved.
//

import UIKit
import MapKit

// Displays the location of all the Apple Pay Banks on a Map
class AllFoodsViewController: UIViewController {
    
    var allFoodsArray = [Food]()
    var allFoodNames:[String] = []
    
    var selectedPin: MKPlacemark?
    
    let locationManager = CLLocationManager()
    var matchingItems: [MKMapItem] = []
    var annotations = [MKPointAnnotation]()
    @IBOutlet var mapView: MKMapView!
    var location = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("RELOADING.")
        
        for food in allFoodsArray {
            var cleanFood = food.name.replacingOccurrences(of: "’", with: "'", options: .regularExpression, range: nil)
            cleanFood = cleanFood.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            allFoodNames.append(cleanFood)
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
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
extension AllFoodsViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("LOCATION MANAGER")
        location = locations.first!
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        print("LOCATION MANAGER OVER.")
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        print("didfinishrenderign!")
        getLocations()
        
    }
    
    /*func getLocations() {
        for shop in allFoodsArray {
            addPinToMap(shop.name)
            print("shop", shop.name)
        }
    }*/
    
    
    func getLocations() {
        let request = MKLocalSearchRequest()
        let keywords = ["restaurants", "fast food", "grocery", "pastry", "bakery"]
        
        for keyword in keywords {
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
                    if(self.allFoodNames.contains(businessName)){
                        self.matchingItems.append(item)
                        self.createAnnotations(item)
                    }
                }
                self.mapView.addAnnotations(self.annotations)
            }
        }
        
        
        //        for bank in allBanksArray[1200,allBanksArray.count-1] {
        //            print(bank.name)
        //            addPinToMap(bank.name)
        //        }
        
    }

    
    func addPinToMap(_ foodName: String) {
        
        print(foodName)
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = foodName
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let region = MKCoordinateRegion(center: (location.coordinate), span: span)
        request.region = region
        //print(request.region)
        let search = MKLocalSearch(request: request)
        //print("REQUEST")
        //print(request.naturalLanguageQuery)
        //print(request.region)
        //print(search)
        search.start { (response, error) in
            if (error != nil) {
                print(error)
                return
            }
            for item in (response?.mapItems)! {
                let businessName = item.name! as String
                if(self.allFoodNames.contains(businessName)){
                    self.matchingItems.append(item)
                    self.createAnnotations(item)
                    print("createing annotation.!.")
                }
            }
            //print("ADDING")
            self.mapView.addAnnotations(self.annotations)
        }
//        search.start { response, _ in
//            //print(response)
//            guard let response = response else {
//
//                return
//            }
//            for item in response.mapItems {
//                let businessName = item.name! as String
//                if(self.allFoodNames.contains(businessName)){
//                    self.matchingItems.append(item)
//                    self.createAnnotations(item)
//                    print("createing annotation.!.")
//                }
//            }
//            print("ADDING")
//            self.mapView.addAnnotations(self.annotations)
//            self.annotations.removeAll()
//        }
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
        print("error:: \(error)")
    }
}

/*
 For the directions button to annotations (clicked pin) on map
 */
extension AllFoodsViewController : MKMapViewDelegate {
    
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

