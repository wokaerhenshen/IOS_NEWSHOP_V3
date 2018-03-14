//
//  ViewController.swift
//  IOSshop_v1
//
//  Created by Carolyn Ho on 3/5/18.
//  Copyright © 2018 Carolyn Ho. All rights reserved.
//

//my change!!!

import UIKit
import CoreData

struct goodStruct : Codable {
    var id : Int!
    var categoryId : Int!
    var price : Decimal!
    var name : String!
    var brief : String!
    
    enum CodingKeys : String, CodingKey{
        case id = "goods_id"
        case categoryId = "cat_id"
        case price = "shop_price"
        case name = "goods_name"
        case brief = "goods_brief"
    }
    
    init(Initid:Int,InitcategoryId :Int, Initprice:Decimal, Initname:String,Initbrief:String) {
        self.id = Initid
        self.categoryId = InitcategoryId
        self.price = Initprice
        self.name = Initname
        self.brief = Initbrief
    }
    
}

class ViewController: UIViewController {
    
    var jsonGoods : [goodStruct]!
    //var window: UIWindow?
    let defaults = UserDefaults.standard
    
    
    
    @IBAction func signOut(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func defaultTheme(_ sender: UIButton) {
        print("default theme clicked")
        //window?.tintColor = UIColor.blue
        UIApplication.shared.delegate?.window??.tintColor = UIColor.black
        defaults.set(true, forKey:"myDefaultTheme")
    }
    
    
    @IBAction func greenTheme(_ sender: UIButton) {
        //window?.tintColor = UIColor.green
        UIApplication.shared.delegate?.window??.tintColor = UIColor.red
        defaults.set(false, forKey:"myDefaultTheme")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var myBool:Bool!
        myBool = defaults.bool(forKey: "myDefaultTheme")
        if (myBool == nil || myBool == true){
            UIApplication.shared.delegate?.window??.tintColor = UIColor.black
        }else{
            UIApplication.shared.delegate?.window??.tintColor = UIColor.red
        }
        //The dispatchGroup is going to make functions async, but this time our function is already saync, so what
        //we need to do is to make the main thread waiting for it.
        // Do any additional setup after loading the view, typically from a nib.
//        let group = DispatchGroup()
//        group.enter()
//        DispatchQueue.global().async {
//            self.syncFromWebAPI()
//            group.leave()
//        }
//        group.wait()
        //group.notify(queue: .main){
        //print(self.jsonGoods[1].name)

        // }
        //cleanDataBase()
        let context = self.getContext()
        let goodFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Goods")
        let goods = try!context.fetch(goodFetch)
        print(goods.count)
        if (goods.count == 0){
            print("start the sync from webapi")
            self.syncFromWebAPI()
            self.resetDataBase(goods: jsonGoods)
        }
        
    
        
//        let cartFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
//        let cartGoods = try!context.fetch(cartFetch)
//        if (cartGoods.count == 0){
//            print("start seeding to the cart")
//            self.seedCart()
//        }else{
//            print("data already exist in the cart")
//        }
        
        
    }
    
    
    
    func syncFromWebAPI(){
         // semaphore with count equal to zero is useful for synchronizing completion of work
        let sema = DispatchSemaphore(value: 0);
        //below is for catching data from web API
        let urlString = "https://karlshopv1.azurewebsites.net/tokenapi/public"
        guard let url = URL(string : urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url){(data,response,err)in
            guard let data = data else {return}
            do{
                let decoder = JSONDecoder()
                let myData = try decoder.decode([goodStruct].self, from:data)
                self.jsonGoods = myData
            }catch let err{
                print("Err",err)
                
            }
            // Signal that we are done
            sema.signal();
            }.resume()
        
        // Now we wait until the response block will send send a signal
        sema.wait()
        
    }
    
    func resetDataBase(goods : [goodStruct]){
        self.cleanDataBase()
        var i  = 0
        while (i < goods.count-1){
            print(goods[i].name)
            saveGood(id: goods[i].id, categoryId: goods[i].categoryId, name: goods[i].name, price: goods[i].price, brief: goods[i].brief)
            i += 1
        }
        
    }
    
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveGood(id:Int, categoryId:Int, name:String, price:Decimal, brief:String){
        let context = getContext()
        let GoodEntity = NSEntityDescription.entity(forEntityName: "Goods", in: context)!
        let good = NSManagedObject(entity: GoodEntity, insertInto: context)
        good.setValue(id, forKey: "id")
        good.setValue(categoryId, forKey: "categoryId")
        good.setValue(name, forKey: "name")
        good.setValue(price, forKey: "price")
        good.setValue(brief, forKey: "brief")
        
        do{
            try context.save()
        }catch{
            
        }
        
    }
    
    func cleanDataBase(){
        let context = getContext()
        let delete = NSBatchDeleteRequest(fetchRequest : Goods.fetchRequest())
        
        do{
            try context.execute(delete)
            print("successfully cleaning the database")
        }catch{
            
        }
    }
    
    func seedCart(){
        let context = getContext()
        let CartEntity = NSEntityDescription.entity(forEntityName: "Cart", in: context)!
        let cartGood = NSManagedObject(entity: CartEntity, insertInto: context)
        cartGood.setValue(1, forKey: "id")
        cartGood.setValue("testGood", forKey: "name")
        cartGood.setValue(7, forKey: "quantity")
        do{
            try context.save()
        }catch{
            
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        if (segue.identifier == "toList") {
            print("Going to Product View.")
        }
        if(segue.identifier == "toCart") {
            print("Going to Cart View.")
        }
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

