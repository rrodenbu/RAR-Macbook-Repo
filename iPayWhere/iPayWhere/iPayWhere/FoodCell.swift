//
//  FoodCell.swift
//  iPayWhere
//
//  Created by Riley Rodenburg on 9/4/16.
//  Copyright © 2016 buddhabuddha. All rights reserved.
//

import UIKit

class FoodCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    
    var food: Food! {
        didSet {
            nameLabel.text = food.name
        }
    }
}
