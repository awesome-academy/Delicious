//
//  Step.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation
import ObjectMapper

struct Step: Mappable {
    var number: Int = 0
    var step = ""
    var ingredients = [Ingredient]()
    var equipment = [String]()

    init() {

    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        number <- map["number"]
        step <- map["step"]
        ingredients <- map["ingredients"]
        equipment <- map["equipment"]
    }

}
