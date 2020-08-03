//
//  FavoriteUseCase.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 sun. All rights reserved.
//

protocol FavoriteUseCaseType {
    func getFavoriteRecipes() -> Observable<[FavoriteRecipe]>
    func remove(recipe: FavoriteRecipe) -> Observable<Void>
}

struct FavoriteUseCase: FavoriteUseCaseType {

    func getFavoriteRecipes() -> Observable<[FavoriteRecipe]> {
        // TODO: Add Fetch data
        return Observable.just([])
    }
    
    func remove(recipe: FavoriteRecipe) -> Observable<Void> {
        // TODO: Add Fetch data
        return Observable.just(())
    }
}
