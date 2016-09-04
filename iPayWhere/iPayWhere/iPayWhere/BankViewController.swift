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
    
    let locationManager = CLLocationManager()
    var matchingItems: [MKMapItem] = []
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        print("data from ReceiveViewController is \(bankSelected)")
        selectedBank = bankSelected
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
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
        let name = item.name
        print(name)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(name)"
        annotation.subtitle = ""
        annotations.append(annotation)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
    
    
}
