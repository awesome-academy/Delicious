//
//  ShopingList.swift
//  Delicious
//
//  Created by HoaPQ on 7/15/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

struct ShoppingList: RecipeType {
    var id: Int
    var title: String
    var readyInMinutes: Int
    var servings: Int
    var image: String
    var creditsText: String
    var ingredients: [ShortIngredient]
}

extension ShoppingList {
    init(from recipe: RecipeInformation) {
        id = recipe.id
        title = recipe.title
        readyInMinutes = recipe.readyInMinutes
        servings = recipe.servings
        image = recipe.image
        creditsText = recipe.creditsText
        ingredients = recipe.extendedIngredients.map { ShortIngredient(from: $0) }
    }
}

extension ShoppingList: CoreDataModel {
    static var primaryKey: String {
        return "id"
    }
    
    var modelID: Int {
        return id
    }
}
