//
//  RecipeInfoRequest.swift
//  Delicious
//
//  Created by HoaPQ on 8/5/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

final class RecipeInfoRequest: BaseRequest {
    init(id: Int) {
        let body = ["includeNutrition": "true"]
        super.init(url: String(format: URLs.API.informationUrl, id), body: body)
    }
}
