//
//  AutoCompletion.swift
//  Delicious
//
//  Created by HoaPQ on 8/5/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation
import ObjectMapper

struct AutoCompletion: Mappable {
    var id: Int = 0
    var title = ""
    var imageType = ""
    
    init(title: String) {
        self.title = title
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        imageType <- map["imageType"]
    }
}
