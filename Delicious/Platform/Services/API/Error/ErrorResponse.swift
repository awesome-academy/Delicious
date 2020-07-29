//
//  ErrorResponse.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation
import ObjectMapper

class ErrorResponse: Mappable {
    var message: String?
    var code: Int?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        code <- map["code"]
    }
}
