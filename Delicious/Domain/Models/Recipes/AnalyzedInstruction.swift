//
//  AnalyzedInstructions.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation
import ObjectMapper

struct AnalyzedInstruction: Mappable {
    var name = ""
    var steps = [Step]()

    init() {

    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        name <- map["name"]
        steps <- map["steps"]
    }

}
