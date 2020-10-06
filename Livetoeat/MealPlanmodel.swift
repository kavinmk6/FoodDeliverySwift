//
//  MealPlans.swift
//  Livetoeat
//
//  Created by Kavin Prabu on 2020-06-01.
//  Copyright © 2020 KavinPrabu. All rights reserved.
//

import Foundation

class Mealplanmodel:Codable {
    var name:String
    var descp:String
    var calorie:Double
    var price:Double
    var image:String
    
     init() {
        
        self.name=""
        self.descp=""
        self.calorie=0.0
        self.price=0.0
        self.image=""
    }
}


