//
//  LocationSearch.swift
//  iPayWhere
//
//  Created by Riley Rodenburg on 9/2/16.
//  Copyright © 2016 buddhabuddha. All rights reserved.
//

import UIKit
import MapKit

func getLocations() -> [MKMapItem] {
    
    var matchingItems: [MKMapItem] = []
    let mapView: MKMapView? = MKMapView()
    
    let request = MKLocalSearchRequest()
    request.naturalLanguageQuery = "Target"
    request.region = (mapView?.region)!
    let search = MKLocalSearch(request: request)
    
    search.start { response, _ in
        guard let response = response else {
            return
        }
        matchingItems = response.mapItems
    }
    return matchingItems
}
