//
//  FavoriteNavigator.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 sun. All rights reserved.
//

protocol FavoriteNavigatorType {
    func toInfomation(recipe: RecipeType)
    func showDeletionConfirm(recipe: FavoriteRecipe) -> Driver<FavoriteRecipe>
}

struct FavoriteNavigator: FavoriteNavigatorType {
    unowned let navigationController: UINavigationController
    
    func toInfomation(recipe: RecipeType) {
        let recipeInfoVC = RecipeInfoViewController.instantiate()
        let navigator = RecipeInfoNavigator(navigationController: navigationController)
        let useCase = RecipeInfoUseCase()
        let viewModel = RecipeInfoViewModel(navigator: navigator, useCase: useCase, recipe: recipe)
        recipeInfoVC.bindViewModel(to: viewModel)
        
        navigationController.pushViewController(recipeInfoVC, animated: true)
    }
    
    func showDeletionConfirm(recipe: FavoriteRecipe) -> Driver<FavoriteRecipe> {
        return Observable<FavoriteRecipe>.create { observable in
            self.navigationController
                .showAlertConfirm(title: "Remove confirm",
                                  message: Constant.favoriteRemoveConfirm,
                                  confirmHandler: {
                                      observable.onNext(recipe)
                                      observable.onCompleted()
                                  }, cancelHandler: {
                                      observable.onCompleted()
                                  })
            return Disposables.create {
                observable.onCompleted()
            }
        }.asDriverOnErrorJustComplete()
    }
}
