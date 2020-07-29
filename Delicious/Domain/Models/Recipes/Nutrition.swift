//
//  Nutrition.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation
import ObjectMapper

struct Nutrition: Mappable {
    var nutrients = [Nutrient]()
    var caloricBreakdown = CaloricBreakdown()
    
    init() {
        
    }

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {
		nutrients <- map["nutrients"]
        caloricBreakdown <- map["caloricBreakdown"]
	}

}
