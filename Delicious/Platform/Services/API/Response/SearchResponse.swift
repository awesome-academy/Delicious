//
//  SearchResponse.swift
//  Delicious
//
//  Created by HoaPQ on 8/5/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation
import ObjectMapper

struct SearchResponse: Mappable {
    var offset: Int = 0
    var number: Int = 0
    var results = [RecipeInformation]()
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        offset <- map["offset"]
        number <- map["number"]
        results <- map["results"]
    }
}
