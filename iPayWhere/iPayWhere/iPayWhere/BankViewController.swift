//
//  BankViewController.swift
//  iPayWhere
//
//  Created by Riley Rodenburg on 9/2/16.
//  Copyright © 2016 buddhabuddha. All rights reserved.
//

import UIKit
import MapKit

var selectedBank : String = ""

class BankViewController: UIViewController {

    var bankSelected : String = ""
    var selectedPin: MKPlacemark?
    
    let locationManager = CLLocationManager()
    var matchingItems: [MKMapItem] = []
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        print("data from ReceiveViewController is \(bankSelected)")
        
        selectedBank = bankSelected
        
        self.title = "\(bankSelected) Locations";
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Arial", size: 12.0)!];
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func parseAddress(selectedItem:MKPlacemark) -> String {
        
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil &&
            selectedItem.thoroughfare != nil) ? " " : ""
        
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
            (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil &&
            selectedItem.administrativeArea != nil) ? " " : ""
        
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        
        return addressLine
    }
    
    func getDirections(){
            let mapItem = MKMapItem(placemark: selectedPin!)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMapsWithLaunchOptions(launchOptions)
    }
    
//    func getDirections(){
//        if let selectedPin = selectedPin {
//            let mapItem = MKMapItem(placemark: selectedPin)
//            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
//            mapItem.openInMapsWithLaunchOptions(launchOptions)
//        }
//    }
}

extension BankViewController : CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        print(region)
        mapView.setRegion(region, animated: true)
        
    }
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView!, fullyRendered: Bool) {
        getLocations()
    }
    
    func getLocations() {
        let request = MKLocalSearchRequest()
        //print(selectedBank)
        request.naturalLanguageQuery = selectedBank
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler { response, _ in
            guard let response = response else {
                return
            }
            for item in response.mapItems {
                self.matchingItems.append(item)
                self.createAnnotations(item)
            }
            self.mapView.addAnnotations(self.annotations)
        }
    }
    
    func createAnnotations(item: MKMapItem) {
        let latitude = item.placemark.coordinate.latitude
        let longitude = item.placemark.coordinate.longitude
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let name = item.name!
        let annotation = MKPointAnnotation()
        selectedPin = item.placemark
        annotation.coordinate = coordinate
        annotation.title = "\(name)"
        
        annotation.subtitle = parseAddress(selectedPin!)
        annotations.append(annotation)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
    
}

extension BankViewController : MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        
        // Directions button
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), forState: .Normal)
        button.addTarget(self, action: "getDirections", forControlEvents: .TouchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}
