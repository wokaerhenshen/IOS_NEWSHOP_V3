//
//  Cart.swift
//  IOSshop_v1
//
//  Created by karl on 2018-03-08.
//  Copyright © 2018 Carolyn Ho. All rights reserved.
//

import UIKit
import CoreData

struct cartGoods : Codable {
    var id : Int!
    var name : String!
    var quantity : Int!
    
    enum CodingKeys : String , CodingKey{
        case id = "goodId"
        case name = "goodName"
        case quantity = "quantity"
        
    }
    
    init(InitId:Int, InitName:String,InitQuantity:Int) {
        self.id = InitId
        self.name = InitName
        self.quantity = InitQuantity
    }
    
}
