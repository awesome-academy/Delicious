//
//  URLs.swift
//  Delicious
//
//  Created by HoaPQ on 8/3/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

enum URLs {
    enum Image {
        static let ingredient = "https://spoonacular.com/cdn/ingredients_500x500/"
        static let recipe = "https://spoonacular.com/recipeImages/%d-636x393.jpg"
    }
    
    enum API {
        private static let baseUrl = "https://api.spoonacular.com/"
        static let homeUrl = API.baseUrl + "recipes/random"
        static let searchUrl = API.baseUrl + "recipes/complexSearch"
        static let searchByIngredientUrl = API.baseUrl + "recipes/findByIngredients"
        static let informationUrl = API.baseUrl + "recipes/%d/information"
    }
}
