//
//  OrderHistory+CoreDataProperties.swift
//  Livetoeat
//
//  Created by Kavin Prabu on 2020-06-05.
//  Copyright © 2020 KavinPrabu. All rights reserved.
//
//

import Foundation
import CoreData


extension OrderHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderHistory> {
        return NSFetchRequest<OrderHistory>(entityName: "OrderHistory")
    }

    @NSManaged public var ordername: String?
    @NSManaged public var orderprice: Double
    @NSManaged public var username: String?
    @NSManaged public var orderdate: String?

}
