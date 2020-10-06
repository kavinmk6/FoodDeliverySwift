//
//  PlaceOrderViewController.swift
//  Livetoeat
//
//  Created by Kavin Prabu on 2020-06-01.
//  Copyright © 2020 KavinPrabu. All rights reserved.
//

import UIKit
import CoreData

class PlaceOrderViewController: UIViewController {

    var mImage:String=""
    var mName:String=""
    var mPrice:Double = 0.0
    var subtottal:Double = 0.0
    var tax:Double = 0.0
    var total:Double = 0.0
    var tip:Double = 0.0
    var manualTipTotal:Double=0.0
    var defaultTipTotal:Double=0.0
    var descript:String=""
    
    var shakecounter=0
    var todaysDate = ""

    @IBOutlet weak var lbldollars: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblSubtotal: UILabel!
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var tipSegmented: UISegmentedControl!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var txtCouponCode: UITextField!
    @IBOutlet weak var btConfirmOrder: UIButton!
    
    @IBOutlet weak var lblCouponApplied: UILabel!
    @IBOutlet weak var etTip: UITextField!
    @IBOutlet weak var lblDescript: UILabel!
    // for the array of 20 values,the one value is 50 ,so it is 5% chance and six 20's bcoz it is 30% chance
    var couponcodes:[Int] = [50,10,10,10,10,10,10,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var couponAfterShake :Int=0
    var useremail:String=""
    var couponcode:String = ""
    
    var appDelegate=AppDelegate()
    var res = [Customerdetails]()
    @IBOutlet weak var imgMeal: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imgMeal.image = UIImage(named: "\(mImage)")
        lblName.text = mName
        lblPrice.text = "\(mPrice)"
        lblDescript.text = descript
        
        useremail = LoginViewController.userDefault.string(forKey: "userEmail")!
        print("the name is \(useremail)")
        tax = round(mPrice*0.13)
        subtottal=mPrice+tax
        
        lblTax.text = "\(tax)"
        lblSubtotal.text="\(subtottal)"
        etTip.addTarget(self, action: #selector(PlaceOrderViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        tip = subtottal * (10/100)
        defaultTipTotal = subtottal+tip
        lblTotal.text="\(defaultTipTotal)"
        lbldollars.text="CAD"
        
        

    }
    
    func pricecalculator(discount:Double)-> Double  {
        
        if (discount != 0){
        var sub_total = subtottal
        var discount_amount = sub_total * (discount/100)
        subtottal = subtottal - discount_amount
        lblSubtotal.text = "\(subtottal)"
        
        tip = subtottal*(10/100)
        defaultTipTotal = subtottal+tip
            self.tipSegmented.selectedSegmentIndex = 0;
           
            lblCouponApplied.text="\(discount)% coupon applied"
        
        }
        
        return defaultTipTotal

    }
    func getTodaysDate()->String{
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "d/M/yy"
        let myStr : String = formatter.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
        print(myStr)
        return myStr
    }
    @IBAction func btApplyCoupon(_ sender: UIButton) {
        
        if (txtCouponCode.text==""){
            display_alertdailog(title: "Text Empty ", message: "Please type your coupon code", buttonname: "OK")
            
        }
        else{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity1 = NSEntityDescription.entity(forEntityName: "Customerdetails", in: context)
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Customerdetails")
        
        fetchRequest.predicate = NSPredicate(format: "name = %@", useremail)
        
        
        let result = try? context.fetch(fetchRequest)
        res = result as! [Customerdetails]
        
        for obj in res {
            if(obj.couponcode == txtCouponCode.text){
                 display_alertdailog(title: "success", message: "Coupon code Applied", buttonname: "ok")
                var coupPercent = obj.couponpercentage

//                var myDouble = Double(lblTotal.text!)
//                myDouble = total-total*(coupPercent/100)
                
                lblTotal.text = "\(pricecalculator(discount: coupPercent))"
                lbldollars.text="CAD"
                 txtCouponCode.text=""
                obj.couponcode = nil
                obj.coupongeneratedate = nil
                obj.couponpercentage = 0
                do {
                    try context.save()
                    
                    print("coupon removed!")
                } catch let error as NSError  {
                    print("Could not remove \(error), \(error.userInfo)")
                }
            }
            else{
                 display_alertdailog(title: "Invalid Discount Code", message: "Coupon code invalid", buttonname: "ok")
            }
        }
        }
        
    }
    @IBAction func btActionConfirmOrder(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "OrderHistory", in: context)
        let pastorders = NSManagedObject(entity: entity!, insertInto: context)
        
       
        var myDouble = Double(lblTotal.text!)
        print("the price is \(myDouble)")
        pastorders.setValue("\(mName)", forKey: "ordername")
        pastorders.setValue(myDouble, forKey: "orderprice")
        pastorders.setValue("\(getTodaysDate())", forKey: "orderdate")
        pastorders.setValue("\(useremail)", forKey: "username")

        do {
            try context.save()
            print("Details Saved!!!!")
            performSegue(withIdentifier: "mapsegue", sender: self)
        } catch {
            display_alertdailog(title: "Saving Database Failed ", message: "Please look at Database", buttonname: "OK")                          }
        
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        var tp = textField.text
        if (tp != "") {
            self.tipSegmented.selectedSegmentIndex = UISegmentedControl.noSegment
        if let amount = tp {
            
            tip = Double(amount)!
            manualTipTotal = subtottal+tip
            print("tip is \(tip)")
            lblTotal.text = "\(manualTipTotal)"
            lbldollars.text="CAD"

        }
        
        
        }
        else{
            self.tipSegmented.selectedSegmentIndex = 0;

//            var sub_total = Double(lblSubtotal.text!)

            tip = subtottal * (10/100)
            manualTipTotal = subtottal+tip
            print("tip is \(tip)")
            lblTotal.text = "\(manualTipTotal)"
            lbldollars.text="CAD"

        }
    }
    @IBAction func segmentedTipAction(sender: UISegmentedControl) {

        switch tipSegmented.selectedSegmentIndex
        {
        case 0:
            
            let tipamount = subtottal * (10/100)
            tip = tipamount
            
        case 1:
            let tipamount = subtottal * (15/100)
            
            tip = tipamount
            
        case 2:
            let tipamount = subtottal * (20/100)
            
            tip = tipamount
        default:
            tip = subtottal * (10/100)
            break
        }
        
        defaultTipTotal = subtottal+tip
        lblTotal.text="\(defaultTipTotal)"
        lbldollars.text="CAD"
    }
    func display_alertdailog(title:String,message:String,buttonname:String)  {
        
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "\(buttonname)", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
    }

  
}
