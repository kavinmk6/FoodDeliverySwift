//
//  MealPlansViewController.swift
//  Livetoeat
//
//  Created by Kavin Prabu on 2020-06-01.
//  Copyright © 2020 KavinPrabu. All rights reserved.
//

import UIKit

class MealPlansViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    
    
    
    @IBOutlet weak var tableviewMeal: UITableView!
    
    var selfname:String=""
    var selfprice:Double = 0.0
    var selfiamge:String = ""
    var selfdescript:String = ""


    var mealplanmodel:[Mealplanmodel] = []
    // MARK: Variables
    var defaults:UserDefaults!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.defaults = UserDefaults.standard
        let firstime = self.defaults.integer(forKey: "firsttime")
        print("the first time is \(firstime)")
        
        guard let file = openFile() else { return }
        
       mealplanmodel=self.getData(from: file)!
        
        self.tableviewMeal.dataSource = self
        self.tableviewMeal.delegate = self
        tableviewMeal.rowHeight = 250
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return mealplanmodel.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Customcell") as! CustomTableViewCell
        
        cell.bt_addmeal.tag = indexPath.row
        
        cell.lbl_secriptionmeal.numberOfLines=0
        let mealname = mealplanmodel[indexPath.row].name
        let secriptionmeal = mealplanmodel[indexPath.row].descp
        let pricemeal = mealplanmodel[indexPath.row].price
        let caloriecount = mealplanmodel[indexPath.row].calorie
        let iamgename = mealplanmodel[indexPath.row].image
        
        
        cell.lbl_mealname.text = "Name : \( mealname)"
        cell.lbl_secriptionmeal.text = "Description : \( secriptionmeal)"
        cell.lbl_pricemeal.text = "Price : \(pricemeal)"
        cell.lbl_caloriecount.text = "Calorie : \(caloriecount)"
        cell.customImageView.image = UIImage(named: "\(iamgename)")
        
        
        
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        print("fddgdfg vb \(mealplanmodel.count)")
        
        let present = segue.destination as! PlaceOrderViewController
        
        
        present.mName = selfname
        present.mPrice = selfprice
        present.mImage = selfiamge
        present.descript = selfdescript

        
        print("name is \(present.mName)")
        
    }
    @IBAction func bt_action_segue(_ sender: UIButton) {
        
        let i = sender.tag
        print("\(i)")
        selfname = mealplanmodel[i].name
        selfprice = mealplanmodel[i].price
        selfiamge = mealplanmodel[i].image
        selfdescript = mealplanmodel[i].descp
        performSegue(withIdentifier: "placeordersegue", sender: self)

        
    }
    func openFile() -> String? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let finalPath = paths[0]
        
        let filename = finalPath.appendingPathComponent("Mealplandatas.json")
        
        // check if file exists
        let fileExists = FileManager().fileExists(atPath: filename.path)
        
        if (fileExists == true) {
            // load words from saved file
            return filename.path;
        }
        else {
            // open words from default file
            return self.openDefaultFile()
        }
        return nil
    }
    
    
    
    
    
    func openDefaultFile()-> String? {
        
        guard let file = Bundle.main.path(forResource:"Mealplandatas", ofType:"json") else {
            print("Cannot find file")
            return nil;
        }
        print("File found: \(file.description)")
        return file
    }
    
    
    
    func getData(from file:String?) -> [Mealplanmodel]? {
        if (file == nil) {
            print("File path is null")
            return nil
        }
        
        do {
            // open the file
            let jsonData = try String(contentsOfFile: file!).data(using: .utf8)
            print(jsonData)         // outputs: Optional(749Bytes)
            
            // get content of file
            let decodedData =
                try JSONDecoder().decode([Mealplanmodel].self, from: jsonData!)
            
            // DEBUG: print file contents to screen
            dump(decodedData)
            
            return decodedData
        } catch {
            print("Error while parsing file")
            print(error.localizedDescription)
        }
        return nil
    }
    

}
