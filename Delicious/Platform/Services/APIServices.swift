//
//  APIServices.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import RxSwift
import Alamofire
import ObjectMapper

struct APIService {
    
    static let shared = APIService()
    
    private var alamofireManager = Alamofire.SessionManager.default
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
        alamofireManager.adapter = CustomRequestAdapter()
    }
    
    func request<T: Mappable>(input: BaseRequest) ->  Observable<T> {
        
        print("\n------------REQUEST INPUT")
        print("link: %@", input.url)
        print("body: %@", input.body ?? "No Body")
        print("------------ END REQUEST INPUT\n")
        
        return Single<T>.create { single in
            self.alamofireManager.request(input.url,
                                          method: input.requestType,
                                          parameters: input.body,
                                          encoding: input.encoding)
                .validate(statusCode: 200..<500)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        guard let statusCode = response.response?.statusCode else {
                            single(.error(BaseError.unexpectedError))
                            return
                        }
                        if statusCode == 200 {
                            if let object = Mapper<T>().map(JSONObject: value) {
                                single(.success(object))
                            }
                        } else {
                            if let object = Mapper<ErrorResponse>().map(JSONObject: value) {
                                single(.error(BaseError.apiFailure(error: object)))
                            } else {
                                single(.error(BaseError.httpError(httpCode: statusCode)))
                            }
                        }
                        
                    case .failure:
                        single(.error(BaseError.networkError))
                    }
            }
            return Disposables.create()
        }.asObservable()
    }
    
    func request<T: Mappable>(input: BaseRequest) ->  Observable<[T]> {
        
        print("\n------------REQUEST INPUT")
        print("link: %@", input.url)
        print("body: %@", input.body ?? "No Body")
        print("------------ END REQUEST INPUT\n")
        
        return Single<[T]>.create { single in
            self.alamofireManager.request(input.url,
                                          method: input.requestType,
                                          parameters: input.body,
                                          encoding: input.encoding)
                .validate(statusCode: 200..<500)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        guard let statusCode = response.response?.statusCode else {
                            single(.error(BaseError.unexpectedError))
                            return
                        }
                        if statusCode == 200 {
                            if let object = Mapper<T>().mapArray(JSONObject: value) {
                                single(.success(object))
                            }
                        } else {
                            if let object = Mapper<ErrorResponse>().map(JSONObject: value) {
                                single(.error(BaseError.apiFailure(error: object)))
                            } else {
                                single(.error(BaseError.httpError(httpCode: statusCode)))
                            }
                        }
                        
                    case .failure:
                        single(.error(BaseError.networkError))
                    }
            }
            return Disposables.create()
        }.asObservable()
    }
}
