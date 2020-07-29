//
//  AnalyzedInstruction.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation
import ObjectMapper

struct CaloricBreakdown: Mappable {
    var percentProtein: Double = 0
    var percentFat: Double = 0
    var percentCarbs: Double = 0

    init() {

    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        percentProtein <- map["percentProtein"]
        percentFat <- map["percentFat"]
        percentCarbs <- map["percentCarbs"]
    }

}
