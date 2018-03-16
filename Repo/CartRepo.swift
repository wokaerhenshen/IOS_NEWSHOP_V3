//
//  CartRepo.swift
//  IOSshop_v1
//
//  Created by karl on 2018-03-08.
//  Copyright © 2018 Carolyn Ho. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CartRepo {
    
    //let defaults = UserDefaults.standard
    
    static func addToCart(name:String) -> Bool {
        print("start adding to cart")
        //It seems that I can only call static func in a static func.
        let context = getContext()
        if (goodExist(goodName:name)){
            return false
        }
        else{
            let CartEntity = NSEntityDescription.entity(forEntityName: "Cart", in: context)!
            let cartGood = NSManagedObject(entity: CartEntity, insertInto: context)
            cartGood.setValue(maxCartGoodId()+1, forKey: "id")
            cartGood.setValue(name, forKey: "name")
            cartGood.setValue(1, forKey: "quantity")
            do{
                try context.save()
                print("add success!!!")
                return true
            }catch{
                return false
            }
            
        }

    }
    
    static func goodExist(goodName: String)-> Bool{
        let context = getContext()
        let fetchRequest:NSFetchRequest<Cart> = Cart.fetchRequest()
        var oneCart : [Cart]? = nil
        let myPredicate = NSPredicate(format:"name contains[c] %@",goodName)
        fetchRequest.predicate = myPredicate
        do {
            try  oneCart = context.fetch(fetchRequest)
            if (oneCart?.first?.name != nil){
                //print(oneCart?.first?.name)
                return true
            }
            else{
                return false
            }
        }catch{
            return false
        }
    }
    
    
    static func maxCartGoodId() -> Int{
        let context = getContext()
        let cartFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        let cartGoods = try!context.fetch(cartFetch)
        //print(goods.count)
        return cartGoods.count
    }
    
    static func upDate(name:String,quantity: Int){
        let context = getContext()
        let fetchRequest:NSFetchRequest<Cart> = Cart.fetchRequest()
        var oneCart : [Cart]? = nil
        let myPredicate = NSPredicate(format:"name contains[c] %@",name)
        fetchRequest.predicate = myPredicate
        do {
           try  oneCart = context.fetch(fetchRequest)
            oneCart?.first?.setValue(quantity, forKey: "quantity")
            
            do {
                try  context.save()
                print("add success")
            } catch {
                
            }
           
            
        }
        catch{
            
        }
    }
    
    static func onlineUpdate(Id: Int,type: String){
        print("strat update to the .NET database.")
        let myUrl = URL(string:"https://karlshopv1.azurewebsites.net/TokenAPI/updateGoodinCart")
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(UserDefaults.standard.string(forKey: "myToken")!, forHTTPHeaderField:"Authorization")
        request.setValue(UserDefaults.standard.string(forKey: "mysecret")!, forHTTPHeaderField:"secret")
        
        let postString = ["Email":UserDefaults.standard.string(forKey: "myEmail")!,"GoodId":Id,"UpdateType":type] as [String : Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
            print(postString)
        }catch let error{
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            (data,response,err)in
            
            // Check for error
            if err != nil {
                print("error=\(String(describing: err))")
                return
            }
            
            
        }
        task.resume()
    }
    
    static func deleteOneGood(id:Int){
        print("start delete one good")
        let context = getContext()
        let fetchRequest:NSFetchRequest<Cart> = Cart.fetchRequest()
        var oneCart : [Cart]
        print(id)
        let myPredicate = NSPredicate(format:"id contains[c] %@",String(id))
        fetchRequest.predicate = myPredicate
        do {
            try  oneCart = context.fetch(fetchRequest)
            context.delete(oneCart.first!)
            do {
                try context.save()
                
            }catch{
                print("delete fail")
            }
        }catch{
            print("no good is found")
        }
        
    }
    
    
    
    static func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
}
