//
//  Item.swift
//  ios-mini-app-braeburn
//
//  Created by Matthew Leon on 9/26/16.
//  Copyright © 2016 CS4720. All rights reserved.
//

import UIKit

class Item: NSObject {
    
    // MARK: Propetries
    
    var name: String
    
    // MARK: Initilization
    
    init(name: String) {
        // Initialize stored propetries
        self.name = name
    }
}
