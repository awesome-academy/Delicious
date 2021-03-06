//
//  Constants.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

enum Constant {
    static let titleFontSize: CGFloat = 20
    static let appTitle = "Delicious"
    static let homeTitle = "Home"
    static let favoriteTitle = "Favorite"
    static let shoppingListTitle = "Shopping List"
    
    static let emptyMessage = "Your data is not available. Please try again!"
    static let favoriteEmptyMessage = "You do not have any favorite recipes yet!"
    static let shoppingEmptyMessage = "You do not have any shopping lists yet!"
    static let favoriteRemoveConfirm = "Are you sure you want to remove this recipe from Favorite?"
    static let shoppingListRemoveConfirm = "Are you sure you want to remove this recipe from Shopping List?"
    static let shoppingListAddedMessage = "Added to shoping list!"
    
    static let throttle = RxTimeInterval.milliseconds(300)
    
    static let cornerRadius: CGFloat = 15
    static let shadowRadius: CGFloat = 5
    static let shadowOpacity: Float = 0.4
    
    static let tableHeaderSectionHeight: CGFloat = 38
    static let segmentHeight: CGFloat = 44
    
    static let numberPerPage = 10
    static let maxOffsetPage = 900
    
    static let kFirstRun = "kFirstRun"
    
    static let mealTypes = [
        "main course",
        "side dish",
        "dessert",
        "appetizer",
        "salad",
        "bread",
        "breakfast",
        "soup",
        "beverage",
        "sauce",
        "marinade",
        "fingerfood",
        "snack",
        "drink"
    ]
    static let cuisines = [
        "African",
        "American",
        "British",
        "Cajun",
        "Caribbean",
        "Chinese",
        "Eastern European",
        "European",
        "Indian",
        "Italian",
        "Japanese",
        "Korean",
        "Mexican",
        "Middle Eastern",
        "Nordic",
        "Southern",
        "Spanish",
        "Thai",
        "Vietnamese"
    ]
    static let diets = [
        "Gluten Free",
        "Ketogenic",
        "Vegetarian",
        "Lacto-Vegetarian",
        "Ovo-Vegetarian",
        "Vegan",
        "Pescetarian",
        "Paleo",
        "Primal",
        "Whole30"
    ]
}
