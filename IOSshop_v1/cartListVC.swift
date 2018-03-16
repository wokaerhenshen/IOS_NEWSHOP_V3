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
    
    
    let defaults = UserDefaults.standard
    var rawNum : Int!
    var cartGoodsArray = [cartGoods]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //cartGoodsArray = fetchCartGoodsFromDataCore()
        //cartGoodsArray = getCartOnline()
        //rawNum = cartGoodsArray.count
        print("========================================================")
        getCartOnline(token: defaults.string(forKey: "myToken")!, secret: defaults.string(forKey: "mysecret")!)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getCartOnline(token: String , secret : String) {
        //var myCartGoods = [cartGoods]()
        //return myCartGoods
        let myUrl = URL(string:"https://karlshopv1.azurewebsites.net/TokenAPI/IOSShowCart")
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(token, forHTTPHeaderField:"Authorization")
        request.setValue(secret, forHTTPHeaderField:"secret")
        
        let postString = ["Email":defaults.string(forKey: "myEmail")!] as [String:String]
        //
        do {
            
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
            print(request.httpBody!)
            
        }catch let error{
            print(error.localizedDescription)
        }
        
        
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            (data,response,err)in
            guard let data = data else {return}
            // Check for error
            if err != nil {
                print("error=\(String(describing: err))")
                return
            }
            do{
                print("try to get json data")
                let decoder = JSONDecoder()
                //print(data?.count!)
                let testThing = try decoder.decode([cartGoods].self, from: data)
                self.cartGoodsArray =  testThing
                print(testThing)
                
            }catch let err{
                print("i got error when i try to decode json")
                print("Err",err)
            }

            
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        task.resume()
        
        

    }
    
    func fetchCartGoodsFromDataCore()-> [cartGoods]{
        var myCartGoods = [cartGoods]()
        let context = getContext()
        let cartFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let cart = try!context.fetch(cartFetch)
        
        for item in cart as![NSManagedObject]{
            let oneGoodInCart = cartGoods(InitId:item.value(forKey: "id") as! Int,InitName:item.value(forKey: "name") as! String,InitQuantity:item.value(forKey: "quantity") as! Int)
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
            //CartRepo.deleteOneGood(id: cartGoodsArray[indexPath.row].id)
            CartRepo.onlineUpdate(Id: cartGoodsArray[indexPath.row].id,type:"delete")
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
