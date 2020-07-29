//
//  Us.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation
import ObjectMapper

struct Us: Mappable {
    var amount: Double = 0
    var unitShort = ""
    var unitLong = ""

    init() {

    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        amount <- map["amount"]
        unitShort <- map["unitShort"]
        unitLong <- map["unitLong"]
    }

}
