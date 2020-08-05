//
//  RecipeInfoNavigator.swift
//  Delicious
//
//  Created by HoaPQ on 7/31/20.
//  Copyright © 2020 sun. All rights reserved.
//

protocol RecipeInfoNavigatorType {
    func showDeletionConfirm(recipe: FavoriteRecipe) -> Driver<FavoriteRecipe>
    func showAddedToShoppingListMessage()
}

struct RecipeInfoNavigator: RecipeInfoNavigatorType {
    unowned let navigationController: UINavigationController

    func showDeletionConfirm(recipe: FavoriteRecipe) -> Driver<FavoriteRecipe> {
        return navigationController
            .showAlertView(title: "Remove confirm",
                           message: Constant.favoriteRemoveConfirm,
                           style: .alert,
                           actions: [("Yes", .default),
                               ("Cancel", .cancel)])
            .filter { $0 == 0 }
            .map { _ in recipe }
    }

    func showAddedToShoppingListMessage() {
        navigationController.showMessage(title: "Success",
                                         message: Constant.shoppingListAddedMessage)
    }
}
