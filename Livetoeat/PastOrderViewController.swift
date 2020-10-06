//
//  PastOrderViewController.swift
//  Livetoeat
//
//  Created by Kavin Prabu on 2020-06-06.
//  Copyright © 2020 KavinPrabu. All rights reserved.
//

import UIKit
import CoreData
class PastOrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    var mname:String=""
    var mprice:Double = 0.0
    var mdate:String = ""
    var orderhistorypoj:[OrderHisPojo] = []
    
    @IBOutlet weak var mTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        mTableView.delegate=self
        mTableView.dataSource=self
        mTableView.rowHeight=130
        var name:String
            = LoginViewController.userDefault.string(forKey: "userEmail")!
       // var name:String = "xxx"
        print("thwe name is \(name)")

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "OrderHistory")
        request.predicate = NSPredicate(format: "username == %@", "\(name)")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            
            if result.count != 0{
                for data in result as! [NSManagedObject] {
                    
                    let p1 = OrderHisPojo()
                    p1.OrderName = data.value(forKey: "ordername") as! String
                    p1.OrderDate = data.value(forKey: "orderdate") as! String
                    p1.OrderPrice = data.value(forKey: "orderprice") as! Double
                    orderhistorypoj.append(p1)
                    mTableView.reloadData()
                    
                }
            }
            else{
                display_alertdailog(title: "No Orders Found", message: "Try a meal", buttonname: "OK")
                
            }
            
        }
            
        catch {
            
            print("Failed")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return orderhistorypoj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ordercell") as! CustomOrerTableViewCell
        
        cell.mealName.text = orderhistorypoj[indexPath.row].OrderName
        cell.mealDate.text = orderhistorypoj[indexPath.row].OrderDate
        cell.mealPrice.text = "\(orderhistorypoj[indexPath.row].OrderPrice)"


        return cell
    }
    
    func display_alertdailog(title:String,message:String,buttonname:String)  {
        
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "\(buttonname)", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
    }
    

}
