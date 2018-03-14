//
//  goodDetail.swift
//  IOSshop_v1
//
//  Created by karl on 2018-03-08.
//  Copyright © 2018 Carolyn Ho. All rights reserved.
//

import UIKit

class goodDetail: UIViewController {

    var goodName : String!
    var goodPrice : Decimal!
    var goodBrief :String!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var productBrief: UILabel!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(goodName)
        productName.text = goodName
        productPrice.text = goodPrice?.description
        productBrief.text = goodBrief
        // Do any additional setup after loading the view.
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func addToCart(_ sender: UIButton) {
        print("I'm clicked")
        if ( CartRepo.addToCart(name:goodName)){
            let alert = UIAlertController(title: "Add Success",
                                          message: "You have Success Added This Product", preferredStyle: .alert)
            
            let firstAction = UIAlertAction(title: "Done", style: .default) {
                (alert: UIAlertAction!) -> Void in
                print("You pressed yes")
                print("Here is another instruction!")
                
            }
            alert.addAction(firstAction)
            self.present(alert, animated: true, completion: nil)

        }else{
            let alert = UIAlertController(title: "Add Failed",
                                          message: "You have added this product before!", preferredStyle: .alert)
            
            let firstAction = UIAlertAction(title: "Done", style: .default) {
                (alert: UIAlertAction!) -> Void in
//                print("You pressed yes")
//                print("Here is another instruction!")
                
            }
            alert.addAction(firstAction)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
