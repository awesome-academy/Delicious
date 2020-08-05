//
//  RecipeInformation.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import ObjectMapper

struct RecipeInformation: Mappable, RecipeType {
    var vegetarian = false
    var vegan = false
    var glutenFree = false
    var dairyFree = false
    var veryHealthy = false
    var cheap = false
    var veryPopular = false
    var sustainable = false
    var weightWatcherSmartPoints: Int = 0
    var gaps = ""
    var lowFodmap = false
    var aggregateLikes: Int = 0
    var spoonacularScore: Double = 0
    var healthScore: Double = 0
    var creditsText = ""
    var sourceName = ""
    var pricePerServing: Double = 0
    var extendedIngredients = [ExtendedIngredient]()
    var id: Int = 0
    var title = ""
    var readyInMinutes: Int = 0
    var servings: Int = 0
    var sourceUrl = ""
    var image = ""
    var imageType = ""
    var nutrition = Nutrition()
    var summary = ""
    var cuisines = [String]()
    var dishTypes = [String]()
    var diets = [String]()
    var occasions = [String]()
    var winePairing = WinePairing()
    var instructions = ""
    var analyzedInstructions = [AnalyzedInstruction]()
    var originalId = ""
    var identity: Int {
        return id
    }

    init() {

    }

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        vegetarian <- map["vegetarian"]
        vegan <- map["vegan"]
        glutenFree <- map["glutenFree"]
        dairyFree <- map["dairyFree"]
        veryHealthy <- map["veryHealthy"]
        cheap <- map["cheap"]
        veryPopular <- map["veryPopular"]
        sustainable <- map["sustainable"]
        weightWatcherSmartPoints <- map["weightWatcherSmartPoints"]
        gaps <- map["gaps"]
        lowFodmap <- map["lowFodmap"]
        aggregateLikes <- map["aggregateLikes"]
        spoonacularScore <- map["spoonacularScore"]
        healthScore <- map["healthScore"]
        creditsText <- map["creditsText"]
        sourceName <- map["sourceName"]
        pricePerServing <- map["pricePerServing"]
        extendedIngredients <- map["extendedIngredients"]
        id <- map["id"]
        title <- map["title"]
        readyInMinutes <- map["readyInMinutes"]
        servings <- map["servings"]
        sourceUrl <- map["sourceUrl"]
        image <- map["image"]
        imageType <- map["imageType"]
        nutrition <- map["nutrition"]
        summary <- map["summary"]
        cuisines <- map["cuisines"]
        dishTypes <- map["dishTypes"]
        diets <- map["diets"]
        occasions <- map["occasions"]
        winePairing <- map["winePairing"]
        instructions <- map["instructions"]
        analyzedInstructions <- map["analyzedInstructions"]
        originalId <- map["originalId"]
    }
}

extension RecipeInformation {
    init(from type: RecipeType) {
        id = type.id
        title = type.title
        readyInMinutes = type.readyInMinutes
        servings = type.servings
        image = type.image
        creditsText = type.creditsText
    }
}
