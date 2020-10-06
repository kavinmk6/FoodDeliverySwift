//
//  LoginViewController.swift
//  Livetoeat
//
//  Created by Kavin Prabu on 2020-06-01.
//  Copyright © 2020 KavinPrabu. All rights reserved.
//

import UIKit
import  CoreData

class LoginViewController: UIViewController {

    @IBOutlet weak var et_password: UITextField!
    @IBOutlet weak var et_email: UITextField!
    
    var email:String=""
    var password:String=""
    public static let userDefault = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func bt_action_login(_ sender: UIButton) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Customerdetails")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        
        email = et_email.text!
        password = et_password.text!
        if !email.isEmpty && email != ""{
            
            //password should atleast minimum 4 letters
            if !password.isEmpty && password.count>=4{
                
                do {
                    let result = try context.fetch(request)
                    var c=0;

                    if result.count != 0{
                    for data in result as! [NSManagedObject] {
                        c=c+1;
                        print(data.value(forKey: "name") as! String)
                        
                        if email.elementsEqual(data.value(forKey: "name") as! String){
                            
                            if password.elementsEqual(data.value(forKey: "password") as! String){
                                
                                LoginViewController.userDefault.setValue(email, forKey: "userEmail")
                                et_email.text=""
                                et_password.text=""
                                print("sucesss \(email)")

                                performSegue(withIdentifier: "logsegue", sender: self)
                                return
                            }
                            else{
                                display_alertdailog(title: "Incorrect Password", message: "Please enter a correct password", buttonname: "OK")
                            }
                        }
                        else{
                            var count = result.count;
                            if count==c{
                                display_alertdailog(title: "User not found", message: "Please enter a correct email", buttonname: "OK")
                            }
                            
                        }
                        
                    }
                    }
                    else{
                        display_alertdailog(title: "User Not Found", message: "Please signup with a email", buttonname: "OK")

                    }
                    
                }
                    
                catch {
                    
                    print("Failed")
                }
            }
            else{
                display_alertdailog(title: "Empty Password", message: "Please enter a password", buttonname: "OK")
                
            }
        }
        else{
            display_alertdailog(title: "Empty Email", message: "Please enter a Email", buttonname: "OK")
            
            
        }
    }
    
    
    func display_alertdailog(title:String,message:String,buttonname:String)  {
        
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "\(buttonname)", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
    }

}
