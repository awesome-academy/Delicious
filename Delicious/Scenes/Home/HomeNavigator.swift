//
//  HomeNavigator.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 sun. All rights reserved.
//

protocol HomeNavigatorType {
    func toInfomation(recipe: RecipeType)
    func toSearch()
}

struct HomeNavigator: HomeNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toInfomation(recipe: RecipeType) {
        let recipeInfoVC = RecipeInfoViewController.instantiate()
        let navigator = RecipeInfoNavigator(navigationController: navigationController)
        let useCase = RecipeInfoUseCase()
        let viewModel = RecipeInfoViewModel(navigator: navigator, useCase: useCase, recipe: recipe)
        recipeInfoVC.bindViewModel(to: viewModel)
        
        navigationController.pushViewController(recipeInfoVC, animated: true)
    }
    
    func toSearch() {
        let searchVC = SearchViewController.instantiate()
        let navigator = SearchNavigator(navigationController: navigationController)
        let useCase = SearchUseCase()
        let viewModel = SearchViewModel(navigator: navigator, useCase: useCase)
        searchVC.bindViewModel(to: viewModel)
        
        navigationController.pushViewController(searchVC, animated: true)
    }
}
