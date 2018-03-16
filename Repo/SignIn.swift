//
//  SignIn.swift
//  IOSshop_v1
//
//  Created by karl on 2018-03-13.
//  Copyright © 2018 Carolyn Ho. All rights reserved.
//

import UIKit

class SignIn: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    let defaults = UserDefaults.standard
    
    @IBAction func signInButton(_ sender: UIButton) {
        print("I want to sign In!")
        
        let email = userName.text
        self.defaults.set(email,forKey: "myEmail")
        
        let pwd = password.text
        
        let myUrl = URL(string:"https://karlshopv1.azurewebsites.net/TokenAPI/login")
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["Email":email!,"Password":pwd!] as [String:String]
        do {
            
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        }catch let error{
            print(error.localizedDescription)
        }
        
        let task = URLSession.shared.dataTask(with: request){(data: Data?, response:URLResponse?, error:Error?)in
            if error != nil{
                print("ther is error!")
                print("error=\(String(describing:error))")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                if let parseJson = json{
                    let token = parseJson["token"] as? String
                    let secret = parseJson["secret"] as? String
                    print(token!)
                    print(secret!)
                    self.defaults.set(token,forKey: "myToken")
                    self.defaults.set(secret,forKey: "mysecret")
                    DispatchQueue.main.async {
                        let homePage =
                            self.storyboard?.instantiateViewController(withIdentifier: "myNav") as! myNav
                        self.present(homePage,animated: true,completion: nil)
                       // let appDelegate = UIApplication.shared.delegate
//                        appDelegate?.window??.rootViewController = homePage
                    }
                }
                else {
                    print("error in the parse json step")
                }
            }catch {
                print(error)
            }
        }
        task.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let   ?? "nil"
        if (defaults.string(forKey: "myToken") != nil){
            DispatchQueue.main.async {
                let homePage =
                    self.storyboard?.instantiateViewController(withIdentifier: "myNav") as! myNav
                self.present(homePage,animated: true,completion: nil)
                // let appDelegate = UIApplication.shared.delegate
                //                        appDelegate?.window??.rootViewController = homePage
                
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
