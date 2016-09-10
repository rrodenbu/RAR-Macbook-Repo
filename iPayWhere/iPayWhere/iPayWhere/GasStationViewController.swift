//
//  GasStationViewController.swift
//  iPayWhere
//
//  Created by Riley Rodenburg on 9/5/16.
//  Copyright © 2016 buddhabuddha. All rights reserved.
//

import UIKit
import MapKit

var selectedGasStation : String = ""

class GasStationViewController: UIViewController {
    
    var gasStationSelected : String = "" // Passed from ShopsViewController table
    var selectedPin: MKPlacemark?
    let locationManager = CLLocationManager()
    var matchingItems: [MKMapItem] = []
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        selectedGasStation = gasStationSelected
        
        self.title = "\(gasStationSelected) Locations";

        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 15.0)!];
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func getDirections(){
        let mapItem = MKMapItem(placemark: selectedPin!)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMapsWithLaunchOptions(launchOptions)
    }
}

/*
 Customizing the pins and their annotations to include name and address
 */
extension GasStationViewController : CLLocationManagerDelegate {
    
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
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        getLocations()
    }
    
    func getLocations() {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = selectedGasStation
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler { response, _ in
            print(response)
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

/*
 For the directions button to annotations (clicked pin) on map
 */
extension GasStationViewController : MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        
        if annotation is MKUserLocation {
            
            //return nil so map view draws "blue dot" for standard user location
            return nil
            
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        
        // Add direction button to annotation when a pin is clicked
        pinView?.canShowCallout = true //Allows the annotation to have button
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: CGPointZero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), forState: .Normal)
        button.addTarget(self, action: #selector(ShopViewController.getDirections), forControlEvents: .TouchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}

