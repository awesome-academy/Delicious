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
    func getRecipes() -> Observable<[RecipeInformation]> {
        // TODO: Call API
        return Observable.of([])
    }
}
