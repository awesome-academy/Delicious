//
//  ShoppingListNavigator.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 sun. All rights reserved.
//

protocol ShoppingListNavigatorType {
    func showDeletionConfirm(list: ShoppingList) -> Driver<ShoppingList>
    func toInformation(recipe: RecipeType)
}

struct ShoppingListNavigator: ShoppingListNavigatorType {
    unowned let navigationController: UINavigationController
    
    func showDeletionConfirm(list: ShoppingList) -> Driver<ShoppingList> {
        return navigationController
            .showAlertView(title: "Remove confirm",
                           message: Constant.shoppingListRemoveConfirm,
                           style: .alert,
                           actions: [("Yes", .default),
                                     ("Cancel", .destructive)])
            .filter { $0 == 0 }
            .map { _ in list }
    }
    
    func toInformation(recipe: RecipeType) {
        let recipeInfoVC = RecipeInfoViewController.instantiate()
        let navigator = RecipeInfoNavigator(navigationController: navigationController)
        let useCase = RecipeInfoUseCase()
        let viewModel = RecipeInfoViewModel(navigator: navigator, useCase: useCase, recipe: recipe)
        recipeInfoVC.bindViewModel(to: viewModel)
        
        navigationController.pushViewController(recipeInfoVC, animated: true)
    }
}
