//
//  HomeRepositoy.swift
//  Delicious
//
//  Created by HoaPQ on 8/3/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

protocol HomeRespositoryType {
    func getHomeData(input: HomeRequest) -> Observable<[RecipeInformation]>
}

struct HomeRepository: HomeRespositoryType {
    private let api = APIService.shared
    
    func getHomeData(input: HomeRequest) -> Observable<[RecipeInformation]> {
        return api.request(input: input).map { (response: HomeResponse) in
            return response.recipes
        }
    }
}
