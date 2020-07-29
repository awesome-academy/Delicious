//
//  Ingredient.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation
import ObjectMapper

struct Ingredient: Mappable {
    var id: Int = 0
    var name = ""
    var localizedName = ""
    var image = ""

    init() {

    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        localizedName <- map["localizedName"]
        image <- map["image"]
    }

}
