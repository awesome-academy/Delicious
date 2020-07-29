//
//  ExtendedIngredient.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation
import ObjectMapper

struct ExtendedIngredient: Mappable {
    var id: Int = 0
    var aisle = ""
    var image = ""
    var consistency = ""
    var name = ""
    var original = ""
    var originalString = ""
    var originalName = ""
    var amount: Double = 0
    var unit = ""
    var meta = [String]()
    var metaInformation = [String]()
    var measures = Measure()

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        aisle <- map["aisle"]
        image <- map["image"]
        consistency <- map["consistency"]
        name <- map["name"]
        original <- map["original"]
        originalString <- map["originalString"]
        originalName <- map["originalName"]
        amount <- map["amount"]
        unit <- map["unit"]
        meta <- map["meta"]
        metaInformation <- map["metaInformation"]
        measures <- map["measures"]
    }
}
