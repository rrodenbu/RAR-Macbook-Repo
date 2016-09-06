//
//  ShopCell.swift
//  iPayWhere
//
//  Created by Riley Rodenburg on 9/4/16.
//  Copyright © 2016 buddhabuddha. All rights reserved.
//

import UIKit

class ShopCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    
    var shop: Shop! {
        didSet {
            nameLabel.text = shop.name
        }
    }
}