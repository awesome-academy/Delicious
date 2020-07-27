//
//  CustomRequestAdapter.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation
import Alamofire

final class CustomRequestAdapter: RequestAdapter {
    private let userDefault = UserDefaults()
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        if let url = urlRequest.url {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            let apiQuery = URLQueryItem(name: "apiKey", value: APIKey.key)
            components?.queryItems?.append(apiQuery)
            urlRequest.url = components?.url
        }
        return urlRequest
    }
}
