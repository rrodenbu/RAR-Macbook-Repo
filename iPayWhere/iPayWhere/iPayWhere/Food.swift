//
//  Food.swift
//  iPayWhere
//
//  Created by Riley Rodenburg on 9/4/16.
//  Copyright © 2016 buddhabuddha. All rights reserved.
//

import UIKit

struct Food {
    var name: String!
    var image: UIImage?
    
    init(name: String?, image: UIImage?) {
        self.name = name
        self.image = image
    }
}
