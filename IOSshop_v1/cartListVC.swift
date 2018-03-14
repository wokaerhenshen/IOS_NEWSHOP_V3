//
//  cartListVC.swift
//  IOSshop_v1
//
//  Created by karl on 2018-03-08.
//  Copyright © 2018 Carolyn Ho. All rights reserved.
//

import UIKit
import CoreData




class cartListVC: UITableViewController {
    
    var rawNum : Int!
    var cartGoodsArray = [cartGoods]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartGoodsArray = fetchCartGoods()
        //rawNum = cartGoodsArray.count
        print("========================================================")
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func fetchCartGoods()-> [cartGoods]{
        var myCartGoods = [cartGoods]()
        let context = getContext()
        let cartFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let cart = try!context.fetch(cartFetch)
        
        for item in cart as![NSManagedObject]{
            let oneGoodInCart = cartGoods(Initid:item.value(forKey: "id") as! Int,InitName:item.value(forKey: "name") as! String,InitQuantity:item.value(forKey: "quantity") as! Int)
            myCartGoods.append(oneGoodInCart)
        }
        return myCartGoods
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cartGoodsArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "oneCart", for: indexPath) as! myCart_newCell

        // Configure the cell...
        let oneCartGood = cartGoodsArray[indexPath.row]
       // cell.textLabel?.text = oneCartGood.name
        cell.dasd.text = oneCartGood.name
        cell.quantity.text = String(oneCartGood.quantity)
        cell.id = oneCartGood.id
        return cell
    }
    
    static func deleteRow(){
        print("this row is deleted")
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            print(indexPath.row)
            print(cartGoodsArray[indexPath.row].id)
            CartRepo.deleteOneGood(id: cartGoodsArray[indexPath.row].id)
            cartGoodsArray.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if (segue.identifier == "showDetail"){
//            let detailPage = segue.destination as! goodDetail
//            detailPage.goodName = cartGoodsArray[(self.tableView.indexPathForSelectedRow?.row)!
//].name
//            
//            
//        }
//    }
    
    
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

}
