//
//  AddProduct.swift
//  IOSshop_v1
//
//  Created by Carolyn Ho on 3/11/18.
//  Copyright © 2018 Carolyn Ho. All rights reserved.
//

import UIKit
import CoreData

class AddProduct: UIViewController {

    
    
    @IBOutlet weak var goodName: UITextField!
    
    
    @IBOutlet weak var goodPrice: UITextField!
    
    
    @IBOutlet weak var goodBrief: UITextField!
    
    
    @IBAction func addGood(_ sender: UIButton) {
        add(name: goodName.text!, price: Decimal(string: goodPrice.text!)!, brief: goodBrief.text!)
    }
    
     func add (name: String, price: Decimal, brief: String){
        let context = CartRepo.getContext()
        let GoodEntity = NSEntityDescription.entity(forEntityName: "Goods", in: context)!
        let good = NSManagedObject(entity: GoodEntity, insertInto: context)
        good.setValue(AddProduct.generateMaxId()+1, forKey: "id")
        good.setValue(11, forKey: "categoryId")
        good.setValue(name, forKey: "name")
        good.setValue(price, forKey: "price")
        good.setValue(brief, forKey: "brief")
        
        do{
            try context.save()
        }catch{
            
        }
        
    }
    
    @IBAction func cancelAdd(_ sender: UIButton) {
    }
    
    static func generateMaxId() -> Int{
        let context = CartRepo.getContext()
        let goodFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Goods")
        let Goods = try!context.fetch(goodFetch)
        //print(goods.count)
        return Goods.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "cancelAdd"){
            // let addPage = segue.destination as!
            print("back to product list page")
        }
        
        
    }
    

    

}
