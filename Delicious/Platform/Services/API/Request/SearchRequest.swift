//
//  SearchRequest.swift
//  Delicious
//
//  Created by HoaPQ on 8/5/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

final class SearchRequest: BaseRequest {
    init(query: String, tags: [SearchTag], offset: Int = 0) {
        var body = ["query": query,
                    "number": Constant.numberPerPage,
                    "offset": offset] as [String: Any]
        var cuisines = [String]()
        var diets = [String]()
        var types = [String]()
        tags.forEach {
            switch $0 {
            case .cuisine(let text):
                cuisines.append(text)
            case .diet(let text):
                diets.append(text)
            case .type(let text):
                types.append(text)
            default:
                break
            }
        }
        body["cuisine"] = cuisines.joined(separator: ",")
        body["diet"] = diets.joined(separator: ",")
        body["type"] = types.joined(separator: ",")
        super.init(url: URLs.API.searchUrl, requestType: .get, body: body)
    }
}
