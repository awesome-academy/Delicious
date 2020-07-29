//
//  BaseRequest.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation
import Alamofire

class BaseRequest: NSObject {
    
    var url = ""
    var requestType = Alamofire.HTTPMethod.get
    var body: [String: Any]?
    
    init(url: String,
         requestType: Alamofire.HTTPMethod = .get,
         body: [String: Any]? = nil) {
        super.init()
        self.url = url
        self.requestType = requestType
        self.body = body
    }
    
    var encoding: ParameterEncoding {
        switch requestType {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}
