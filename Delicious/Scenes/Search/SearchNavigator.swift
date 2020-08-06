//
//  SearchNavigator.swift
//  Delicious
//
//  Created by HoaPQ on 7/31/20.
//  Copyright © 2020 sun. All rights reserved.
//

protocol SearchNavigatorType {
    func toInformation(recipe: RecipeType)
}

struct SearchNavigator: SearchNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toInformation(recipe: RecipeType) {
        let recipeInfoVC = RecipeInfoViewController.instantiate()
        let navigator = RecipeInfoNavigator(navigationController: navigationController)
        let useCase = RecipeInfoUseCase()
        let viewModel = RecipeInfoViewModel(navigator: navigator, useCase: useCase, recipe: recipe)
        recipeInfoVC.bindViewModel(to: viewModel)
        
        navigationController.pushViewController(recipeInfoVC, animated: true)
    }
}
