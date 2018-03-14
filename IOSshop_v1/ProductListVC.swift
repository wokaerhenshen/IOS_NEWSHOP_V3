//
//  ProductListVC.swift
//  IOSshop_v1
//
//  Created by Carolyn Ho on 3/7/18.
//  Copyright © 2018 Carolyn Ho. All rights reserved.
//

import UIKit
import CoreData

class ProductListVC: UITableViewController {
    
    var rawNum : Int!
    var goodsArray = [goodStruct]()
//    var myGoods : Goods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.reloadData()
       
        
//        let context = getContext()
//        let goodFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Goods")
//        let goods = try!context.fetch(goodFetch)
//        rawNum = goods.count
        goodsArray = fetchObj()
        //let testGood: Goods = goods as! Goods
        //print(testGood.name)
        print("========================================================")
       // print(goods[0].value(forkey:"name"))
//        for data in goods as![NSManagedObject]{
//            print(data.value(forKey:"name") as! String)
//        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"+", style: .plain , target:self,action:"insert")
    }
    
    func fetchObj() -> [goodStruct]{
        var goodArray = [goodStruct]()
        
        let context = getContext()
        let goodFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Goods")
        let goods = try!context.fetch(goodFetch)
        
        for item in goods as![NSManagedObject]{
            let oneGoodinArray = goodStruct(Initid: item.value(forKey: "id") as! Int, InitcategoryId: item.value(forKey: "categoryId") as! Int, Initprice: item.value(forKey: "price") as! Decimal, Initname: item.value(forKey: "name") as! String, Initbrief: item.value(forKey: "brief") as! String)
            goodArray.append(oneGoodinArray)
        }
        
        return goodArray
        
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

        return goodsArray.count
    }
    
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "oneGood", for: indexPath)
        
        let oneGood = goodsArray[indexPath.row]
        //cell.textLable!.text = myGoods[indexPath.row].f
        cell.textLabel?.text = oneGood.name
        return cell
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
            tableView.deleteRows(at: [indexPath], with: .fade)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "showDetail"){
            let detailPage = segue.destination as! goodDetail
            detailPage.goodName = goodsArray[(self.tableView.indexPathForSelectedRow?.row)!
                ].name
            detailPage.goodPrice = goodsArray[(self.tableView.indexPathForSelectedRow?.row)!
                ].price
            detailPage.goodBrief = goodsArray[(self.tableView.indexPathForSelectedRow?.row)!
                ].brief
            
            
        }
        
        if (segue.identifier == "add"){
           // let addPage = segue.destination as!
            print("arrived adding page")
        }
        
        
    }
    

}
