//
//  ShoppingListRepository.swift
//  Delicious
//
//  Created by HoaPQ on 8/4/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

protocol ShoppingListRepositoryType: CoreDataRepository {
    
}

extension ShoppingListRepositoryType where
    Self.ModelType == ShoppingList,
    Self.EntityType == CDShoppingList {
    
    func getShopingLists() -> Observable<[ShoppingList]> {
        return all()
    }
    
    func add(_ items: [ShoppingList]) -> Observable<Void> {
           return addAll(items)
    }
    
    static func map(from item: ShoppingList, to entity: CDShoppingList) {
        entity.id = Int64(item.id)
        entity.title = item.title
        entity.creditsText = item.creditsText
        entity.image = item.image
        entity.readyInMinutes = Int64(item.readyInMinutes)
        entity.ingredients = item.ingredients.map { $0.toClass() }
    }
    
    static func item(from entity: EntityType) -> ModelType? {
        guard let title = entity.title,
              let image = entity.image,
              let creditsText = entity.creditsText,
              let ingredients = entity.ingredients else { return nil }
        return ShoppingList(
            id: Int(entity.id),
            title: title,
            readyInMinutes: Int(entity.readyInMinutes),
            servings: Int(entity.servings),
            image: image,
            creditsText: creditsText,
            ingredients: ingredients.map { $0.toStruct() }
        )
    }
}

struct ShoppingListRepository: ShoppingListRepositoryType {
    
}
