//
//  AllShopsViewController.swift
//  iPayWhere
//
//  Created by Riley Rodenburg on 9/4/16.
//  Copyright © 2016 buddhabuddha. All rights reserved.
//

import UIKit
import MapKit

// Displays the location of all the Apple Pay Banks on a Map
class AllShopsViewController: UIViewController {
    
    var allShopsArray = [Shop]()
    var allShopNames:[String] = []
    
    var selectedPin: MKPlacemark?
    
    let locationManager = CLLocationManager()
    var matchingItems: [MKMapItem] = []
    var annotations = [MKPointAnnotation]()
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(allShopNames.count)
        for shop in allShopsArray {
            var cleanShop = shop.name.replacingOccurrences(of: "’", with: "'", options: .regularExpression, range: nil)
            cleanShop = cleanShop.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            allShopNames.append(cleanShop)
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func getDirections(){
        let mapItem = MKMapItem(placemark: selectedPin!)
        print("#######################")
        print(mapItem.name)
        
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        //mapItem.openInMaps(launchOptions: launchOptions)
    }
}

/*
 Customizing the pins and their annotations to include name and address
 */
extension AllShopsViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(0.75, 0.75)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        getLocations()
        
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        
    }
    
    func getLocations() {
        let request = MKLocalSearchRequest()
        let keywords = ["shopping"]
        
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
                    if(self.allShopNames.contains(businessName)){
                        self.matchingItems.append(item)
                        self.createAnnotations(item)
                    }
                }
                self.mapView.addAnnotations(self.annotations)
            }
        }
        
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
                if(self.allShopNames.contains(businessName)){
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
        print("error:: \(error)")
    }
}

/*
 For the directions button to annotations (clicked pin) on map
 */
extension AllViewController : MKMapViewDelegate {
    
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


