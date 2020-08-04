//
//  FavoriteRepository.swift
//  Delicious
//
//  Created by HoaPQ on 7/14/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import MagicalRecord
import RxSwift

protocol FavoriteRepositoryType: CoreDataRepository {
    
}

extension FavoriteRepositoryType where
    Self.ModelType == FavoriteRecipe,
    Self.EntityType == CDFavoriteRecipe {
    
    func getRecipes() -> Observable<[FavoriteRecipe]> {
        return all()
    }

    func add(_ recipes: [FavoriteRecipe]) -> Observable<Void> {
        return addAll(recipes)
    }
    
    static func map(from item: FavoriteRecipe, to entity: CDFavoriteRecipe) {
        entity.id = Int64(item.id)
        entity.title = item.title
        entity.creditsText = item.creditsText
        entity.image = item.image
        entity.readyInMinutes = Int64(item.readyInMinutes)
        entity.servings = Int64(item.servings)
    }
    
    static func item(from entity: CDFavoriteRecipe) -> FavoriteRecipe? {
        return FavoriteRecipe(
            id: Int(entity.id),
            title: entity.title ?? "",
            readyInMinutes: Int(entity.readyInMinutes),
            servings: Int(entity.servings),
            image: entity.image ?? "",
            creditsText: entity.creditsText ?? ""
        )
    }
}

struct FavoriteRepository: FavoriteRepositoryType { }
