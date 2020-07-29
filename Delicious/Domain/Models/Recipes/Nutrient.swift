//
//  Nutrients.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation
import ObjectMapper

struct Nutrient: Mappable {
    var title = ""
    var amount: Double = 0
    var unit = ""
    var percentOfDailyNeeds: Double = 0

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        title <- map["title"]
        amount <- map["amount"]
        unit <- map["unit"]
        percentOfDailyNeeds <- map["percentOfDailyNeeds"]
    }

}
