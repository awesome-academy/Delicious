//
//  WinePairing.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation
import ObjectMapper

struct WinePairing: Mappable {
    var pairedWines = [String]()
    var pairingText = ""

    init() {

    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        pairedWines <- map["pairedWines"]
        pairingText <- map["pairingText"]
    }

}
