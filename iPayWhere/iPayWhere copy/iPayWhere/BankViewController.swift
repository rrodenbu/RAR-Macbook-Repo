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

    
    var bankSelected : String = "" // Passed from BanksViewController table
    var selectedPin: MKPlacemark?
    let locationManager = CLLocationManager()
    var matchingItems: [MKMapItem] = []
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        selectedBank = bankSelected.replacingOccurrences(of: "’", with: "'", options: .regularExpression, range: nil)
        selectedBank = selectedBank.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        self.title = "\(bankSelected) Locations";
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 15.0)!];
        
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
extension BankViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpanMake(0.75, 0.75)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        print(region)
        mapView.setRegion(region, animated: true)
        
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        getLocations()
    }
    
    func getLocations() {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = selectedBank
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.start { response, _ in
            guard let response = response else {
                return
            }
            for item in response.mapItems {
                let businessName = item.name! as String
                if(businessName == selectedBank) {
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
        let annotation = MKPointAnnotation()
        selectedPin = item.placemark
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
extension BankViewController : MKMapViewDelegate {
    
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
        button.addTarget(self, action: #selector(BankViewController.getDirections), for: .touchUpInside)
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



