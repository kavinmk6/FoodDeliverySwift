//
//  SignupViewController.swift
//  Livetoeat
//
//  Created by Kavin Prabu on 2020-06-01.
//  Copyright © 2020 KavinPrabu. All rights reserved.
//

import UIKit
import CoreData

class SignupViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var et_email: UITextField!
    @IBOutlet weak var et_password: UITextField!
    @IBOutlet weak var et_phonnumber: UITextField!
    
    @IBOutlet weak var img_profilepic: UIImageView!
    
    @IBOutlet weak var bt_setimage: UIButton!
    
    // MARK: Variables
    var imagePicker:UIImagePickerController!
    var email:String = ""
    var password:String = ""
    var phonenumber:String = ""
    var url:URL?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func bt_action_takephoto(_ sender: UIButton) {
        
        self.imagePicker = UIImagePickerController()
        
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera) == false) {
            print("Hey, you don't have a Camera , sorry!")
            // swap them to using the camera
            return
        }
        
        self.imagePicker.sourceType = .camera
        self.imagePicker.delegate = self
        
        self.present(self.imagePicker, animated:true)
        
        
    }
    
    
    @IBAction func bt_action_choosephoto(_ sender: UIButton) {
        
        self.imagePicker = UIImagePickerController()
        
        
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == false) {
            print("Hey, you don't have a photo gallery, sorry!")
            // swap them to using the camera
            return
        }
        
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.delegate = self
        
        self.present(self.imagePicker, animated:true)
        
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // MARK: Handle images
        print("Calling the picker view function")
        
        // what do you want to do after the person presses "Use Photo?"
        // - do you want to save the photo? display the photo? discard it?
        // - do something else?
        // In example below, we are closing the picker
        self.imagePicker.dismiss(animated: true, completion: nil)
        
        // the camera image is stored in function info parameter
        let photoTakenFromCamera = info[.originalImage] as? UIImage
        self.img_profilepic.image = photoTakenFromCamera
        
        url = info[UIImagePickerController.InfoKey.imageURL] as? URL
        print("Path to your image \(String(describing: url))")
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bt_action_regsiter(_ sender: Any) {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Customerdetails", in: context)
        let newcustomer = NSManagedObject(entity: entity!, insertInto: context)
        
        print("clicked")
        email = et_email.text!
        password = et_password.text!
        phonenumber = et_phonnumber.text!
        if !email.isEmpty && email != ""{
            
            
            if !password.isEmpty && password.count>=4{
                
                
                if !phonenumber.isEmpty && phonenumber.count==10{
                    
                    if img_profilepic.image != nil{
                        
                        newcustomer.setValue("\(email)", forKey: "name")
                        newcustomer.setValue("\(password)", forKey: "password")
                        newcustomer.setValue("\(phonenumber)", forKey: "phonnumber")
                        newcustomer.setValue("\(String(describing: url))", forKey: "imageprofile")
                        
                        
                        do {
                            try context.save()
                            
                            LoginViewController.userDefault.setValue("\(email)", forKey: "userEmail")
                            performSegue(withIdentifier: "regsegue", sender: self)
                            print("Saved!!!!")
                        } catch {
                            display_alertdailog(title: "Saving Database Failed ", message: "Please look at Database", buttonname: "OK")                          }
                    }
                    else{
                        display_alertdailog(title: "Image Required ", message: "Please Select one image", buttonname: "OK")
                    }
                    
                    
                    
                }
                else{
                    display_alertdailog(title: "Phonenumber Empty", message: "Please enter a valid Phonenumber", buttonname: "OK")
                }
                
                
                
            }
            else{
                display_alertdailog(title: "Password Empty", message: "Please enter a valid password", buttonname: "OK")
                
            }
        }
        else{
            display_alertdailog(title: "Email Empty", message: "Please enter a valid email", buttonname: "OK")
        }
        
        
    }
    
    func display_alertdailog(title:String,message:String,buttonname:String)  {
        
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "\(buttonname)", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
    }
    

}
