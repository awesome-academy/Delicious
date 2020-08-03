//
//  HomeRequest.swift
//  Delicious
//
//  Created by HoaPQ on 8/3/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

final class HomeRequest: BaseRequest {
    required init(number: Int = 20) {
        let body = ["limitLicense": "false",
                    "instructionsRequired": "true",
                    "number": number] as [String: Any]
        super.init(url: URLs.API.homeUrl, requestType: .get, body: body)
    }
}
