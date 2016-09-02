//
//  BankCell.swift
//  iPayWhere
//
//  Created by Riley Rodenburg on 9/1/16.
//  Copyright © 2016 buddhabuddha. All rights reserved.
//

import UIKit

func imageForBank() -> UIImage? {
    let imageName = "Shop-30"
    return UIImage(named: imageName)
}

class BankCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bankImageView: UIImageView!
    
    var bank: Bank! {
        didSet {
            nameLabel.text = bank.name
            bankImageView.image = imageForBank();
        }
    }

}

