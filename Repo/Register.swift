//
//  Register.swift
//  IOSshop_v1
//
//  Created by karl on 2018-03-13.
//  Copyright © 2018 Carolyn Ho. All rights reserved.
//

import UIKit

class Register: UIViewController {
    
    
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func signUp(_ sender: UIButton) {
        print("I want to sign Up!")
        
        let myEmail = email.text
        let myPassword = password.text
        
        let myUrl = URL(string:"https://karlshopv1.azurewebsites.net/TokenAPI/register")
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
         let postString = ["Email":myEmail!,"Password":myPassword!] as [String:String]
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
                    print(token!)
                    self.displayMessage(userMessage: "Success!!!!!")
                    
                    
                    
                    
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayMessage(userMessage:String) -> Void{
        DispatchQueue.main.async{
            let alertController = UIAlertController(title:"Helo From Karl!", message : userMessage,preferredStyle: .alert)
            let OKAction = UIAlertAction(title:"OK",style: .default){
                (action:UIAlertAction!)in
                print("tapped")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController,animated: true,completion: nil)
            
            
            
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
