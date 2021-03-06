//
//  myCart_newCell.swift
//  IOSshop_v1
//
//  Created by karl on 2018-03-08.
//  Copyright © 2018 Carolyn Ho. All rights reserved.
//

import UIKit

class myCart_newCell: UITableViewCell {
    
    @IBOutlet weak var dasd: UILabel!
    
    @IBOutlet weak var quantity: UILabel!
    
    @IBOutlet weak var add: UIButton!
    
    @IBOutlet weak var minus: UIButton!
    
//    @IBOutlet weak var delete: UIButton!
    
    var id:Int = 0
    
    @IBAction func addQuantity(_ sender: UIButton) {
        print("add One")
        self.quantity.text = String(Int(self.quantity.text!)!+1)
        CartRepo.onlineUpdate(Id: id,type:"add")
        //CartRepo.upDate(name: self.dasd.text!, quantity:  Int(self.quantity.text!)!)
    }
    
    
    @IBAction func minusQuantity(_ sender: UIButton) {
        print("Minus One")
        self.quantity.text = String(Int(self.quantity.text!)!-1)
        CartRepo.onlineUpdate(Id: id,type:"minus")
        if (self.quantity.text == "1"){
            minus.isEnabled = false
        }else {
            minus.isEnabled = true
        }
        //CartRepo.upDate(name: self.dasd.text!, quantity:  Int(self.quantity.text!)!)
    }
    
    
    // this become useless because we use the default stuff to do the delete operation.
//    @IBAction func deleteGood(_ sender: UIButton) {
//        print(" start delete this Good!")
//        CartRepo.deleteOneGood(id: self.id)
//        cartListVC.deleteRow()
//
//    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if (self.quantity.text == "1"){
            minus.isEnabled = false
        }else {
            minus.isEnabled = true
        }
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if (self.quantity.text == "1"){
            minus.isEnabled = false
        }else {
            minus.isEnabled = true
        }
        // Configure the view for the selected state
    }

}
