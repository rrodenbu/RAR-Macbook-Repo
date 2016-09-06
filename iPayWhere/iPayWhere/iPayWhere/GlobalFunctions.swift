//
//  GlobalFunctions.swift
//  iPayWhere
//
//  Created by Riley Rodenburg on 9/4/16.
//  Copyright © 2016 buddhabuddha. All rights reserved.
//

import MapKit

/*
 String formats an address passed as MKPlacemark
*/
func parseAddress(selectedItem:MKPlacemark) -> String {
    
    // put a space between street number and street name
    let firstSpace = (selectedItem.subThoroughfare != nil &&
        selectedItem.thoroughfare != nil) ? " " : ""
    
    // put a comma between street and city/state
    let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
        (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
    
    // put a space between states with two words (Washington DC)
    let secondSpace = (selectedItem.subAdministrativeArea != nil &&
        selectedItem.administrativeArea != nil) ? " " : ""
    
    // concatinate
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


