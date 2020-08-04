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
    let repository = FavoriteRepository()
    
    func getFavoriteRecipes() -> Observable<[FavoriteRecipe]> {
        return repository.getRecipes()
    }
    
    func remove(recipe: FavoriteRecipe) -> Observable<Void> {
        return repository.deleteItem(havingID: recipe.id)
    }
}
