//
//  Order.swift
//  CupcakeCorner
//
//  Created by Gavin Butler on 04-08-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import Foundation

class OrderWrapper: ObservableObject {
    @Published var order: Order = Order()
}

struct Order: Codable {
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    var specialRequestEnabled = false {
        didSet {
            if !specialRequestEnabled {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        //Check if fields are empty
        !(name.isEmpty ||
          streetAddress.isEmpty ||
          city.isEmpty ||
          zip.isEmpty ||
        //...and strip each field of spaces to see if there was only white space there
          name.filter{ !$0.isWhitespace }.count == 0 ||
          streetAddress.filter{ !$0.isWhitespace }.count == 0 ||
          city.filter{ !$0.isWhitespace }.count == 0 ||
          zip.filter{ !$0.isWhitespace }.count == 0
        )
    }
    
    var cost: Double {
        var cost = Double(quantity * 2)
        cost += Double(type) / 2
        
        if extraFrosting {
            cost += Double(quantity)
        }
        
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
}

