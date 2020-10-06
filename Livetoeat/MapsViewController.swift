//
//  MapsViewController.swift
//  Livetoeat
//
//  Created by Kavin Prabu on 2020-06-05.
//  Copyright © 2020 KavinPrabu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData
class MapsViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate{

    @IBOutlet weak var lblStatusORder: UILabel!
    @IBOutlet weak var lblCouponCode: UILabel!
    var manager = CLLocationManager()

    var circle = MKCircle()
    var shakecounter = 0
    var res = [Customerdetails]()
    var couponcodes:[Int] = [50,10,10,10,10,10,10,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var couponAfterShake :Int=0
    var useremail:String=""
    var couponcode:String = ""
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        useremail = LoginViewController.userDefault.string(forKey: "userEmail")!

        mapView.delegate = self

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        manager.desiredAccuracy = kCLLocationAccuracyBest;

        manager.startUpdatingLocation()
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        
        let title = "Oakville Test"
        let coordinate = CLLocationCoordinate2DMake(43.6544, -79.3807)
        let regionRadius = 150.0
        
        // setup region
        let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), radius: regionRadius, identifier: title)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        manager.startMonitoring(for: region)
        manager.startUpdatingLocation()
        
        // setup annotation
        let annotationView = MKPointAnnotation()
        annotationView.coordinate = coordinate;
        annotationView.title = "\(title)";
        mapView.addAnnotation(annotationView)
        
        // setup circle
        let circle = MKCircle(center: coordinate, radius: regionRadius)
        mapView.addOverlay(circle)
        
      


    
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue.withAlphaComponent(0.6)
            renderer.lineWidth = 5.0
            renderer.fillColor = UIColor.blue.withAlphaComponent(0.7)
            return renderer
        } else {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.strokeColor = UIColor.red.withAlphaComponent(0.4)
            circleRenderer.lineWidth = 1.0
            circleRenderer.fillColor = UIColor.red.withAlphaComponent(0.4)
            return circleRenderer
        }
        return nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("\(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for c in locations{
            print(c)
        }
        }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("user entered")
        displayAlertTimer()
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("user Exit")
        
    }


    func displayAlertTimer(){
        
     
        //for demostartion purpose i have set timer  5 seconds
        var tcount = 5
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
            timer in
            
self.lblStatusORder.text = "Dear customer,We started preparing your order,Please give us \(tcount) seconds"
            tcount-=1
            
            if tcount==0{
                timer.invalidate()

                self.displayAlertdailogAction(title: "Order Ready", message: "your order is ready now,please go and pickup", buttonname: "OK",time:timer)
            }
            
        }

    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        print("Shakingggggg")
        
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            shakecounter += 1
            if shakecounter >= 3 {
                shakecounter = 0
                
                var hasPlayers = false
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Customerdetails")
                
                fetchRequest.predicate = NSPredicate(format: "name = %@", useremail)
                var result : [NSManagedObject] = []
                
                print("fetch \(useremail)")
                do {
                    result = try context.fetch(fetchRequest) as! [NSManagedObject]
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
                }
                
                
                
                res = result as! [Customerdetails]
                for object in res {
                    print(object.name)
                    if object.name == useremail {
                        print("fetchnameeee \(useremail)")
                        
                        if object.coupongeneratedate == getTodaysDate(){
                            print("date equal")
                            display_alertdailog(title: "One chance over", message: "you can shake only one time per day,try next day", buttonname: "ok")
                        }
                        else{
                            couponcode = randomString(length:6)
                            couponAfterShake = couponcodes.randomElement()!
                            
                            if couponAfterShake != 0{
                                
                                object.couponcode = couponcode
                                object.couponpercentage = Double(couponAfterShake)
                                object.coupongeneratedate = getTodaysDate()
                                do {
                                    try context.save()
                                    display_alertdailog(title: "\(couponAfterShake)% Discount Code", message: "Use \(couponcode) when next time applying", buttonname: "ok")
                                    lblCouponCode.text=couponcode
                                    print("saved!")
                                } catch let error as NSError  {
                                    print("Could not save \(error), \(error.userInfo)")
                                }
                                
                            }else{
                                object.coupongeneratedate = getTodaysDate()
                                do {
                                    try context.save()
                                    display_alertdailog(title: "No Discount Code", message: "Sorry,you didn't won discount today,try tomorrow", buttonname: "ok")
                                    print("saved!")
                                } catch let error as NSError  {
                                    print("Could not save \(error), \(error.userInfo)")
                                }
                                
                            }
                        }
                        
                    }else{
                        print("user not found \(useremail)")
                    }
                }
            }
            
        }
        print("stpedddd \(shakecounter)")
        
    }
    
    func getTodaysDate()->String{
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "d/M/yy"
        let myStr : String = formatter.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
        print(myStr)
        return myStr
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
    func displayAlertdailogAction(title:String,message:String,buttonname:String,time:Timer)  {
        
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            self.lblStatusORder.text = "Order Pickedup,thankyou for your patience,Enjoy your meal"
        }
        alert.addAction(okAction)
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func display_alertdailog(title:String,message:String,buttonname:String)  {
        
        let alert = UIAlertController(title: "\(title)", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "\(buttonname)", style: UIAlertAction.Style.default, handler: nil))

        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
