//
//  HomeUseCase.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 sun. All rights reserved.
//

protocol HomeUseCaseType {
    func getRecipes() -> Observable<[RecipeInformation]>
}

struct HomeUseCase: HomeUseCaseType {
    let repository: HomeRespositoryType
    
    func getRecipes() -> Observable<[RecipeInformation]> {
        let input = HomeRequest()
        return repository.getHomeData(input: input)
    }
}
