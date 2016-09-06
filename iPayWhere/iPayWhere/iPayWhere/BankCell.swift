//
//  BankCell.swift
//  iPayWhere
//
//  Created by Riley Rodenburg on 9/1/16.
//  Copyright © 2016 buddhabuddha. All rights reserved.
//

import UIKit

class BankCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    var bank: Bank! {
        didSet {
            nameLabel.text = bank.name
        }
    }
}

