//
//  GasStationCell.swift
//  iPayWhere
//
//  Created by Riley Rodenburg on 9/5/16.
//  Copyright © 2016 buddhabuddha. All rights reserved.
//

import UIKit

class GasStationCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    
    var gasStation: GasStation! {
        didSet {
            nameLabel.text = gasStation.name
        }
    }
}