//
//  OnboardingUseCase.swift
//  Delicious
//
//  Created by HoaPQ on 8/6/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

protocol OnboardingUseCaseType {
    func getOnboardingModels() -> [OnboardingModel]
}

struct OnboardingUseCase: OnboardingUseCaseType {
    func getOnboardingModels() -> [OnboardingModel] {
        return [
            OnboardingModel(image: Icon.imgRecipes,
                            title: "Explore More Recipes",
                            content: "Explore 1000+ Recipes in Delicious App. Most Yummy Recipes here Enjoy cooking!"),
            OnboardingModel(image: Icon.imgFavorites,
                            title: "Favorites",
                            content: "Add your favorite recipes item to your favorites in simple steps and easily to manage them"),
            OnboardingModel(image: Icon.imgShoppingList,
                            title: "Shopping List",
                            content: "Add your recipe ingredients item to your shopping list in simple steps and easily to manage them")
        ]
    }
}
