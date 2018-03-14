//
//  Cart.swift
//  IOSshop_v1
//
//  Created by karl on 2018-03-08.
//  Copyright © 2018 Carolyn Ho. All rights reserved.
//

import Foundation

struct cartGoods : Codable {
    var id : Int!
    var name : String!
    var quantity : Int!
    
    init(Initid:Int,InitName:String,InitQuantity:Int) {
        self.id = Initid
        self.name = InitName
        self.quantity = InitQuantity
    }
    
}
