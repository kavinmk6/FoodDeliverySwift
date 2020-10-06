//
//  Customerdetails+CoreDataProperties.swift
//  Livetoeat
//
//  Created by Kavin Prabu on 2020-06-07.
//  Copyright © 2020 KavinPrabu. All rights reserved.
//
//

import Foundation
import CoreData


extension Customerdetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Customerdetails> {
        return NSFetchRequest<Customerdetails>(entityName: "Customerdetails")
    }

    @NSManaged public var couponcode: String?
    @NSManaged public var couponpercentage: Double
    @NSManaged public var imageprofile: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var phonnumber: String?
    @NSManaged public var coupongeneratedate: String?

}
