//
//  RecipeInfoUseCase.swift
//  Delicious
//
//  Created by HoaPQ on 7/31/20.
//  Copyright © 2020 sun. All rights reserved.
//

protocol RecipeInfoUseCaseType {
    func getRecipe(id: Int) -> Observable<RecipeInformation>
    func addToShopingList(recipe: RecipeInformation) -> Observable<Void>
    func addToShopingList(recipe: RecipeInformation, type: RecipeType) -> Observable<Void>
    func updateFavorite(recipe: RecipeType, status: Bool) -> Observable<Void>
    func checkFavorite(recipe: RecipeType) -> Observable<Bool>
    func checkShoping(recipe: RecipeType) -> Observable<Bool>
    func getDataSource(index: Int, from recipe: RecipeInformation) -> [RecipeTableViewSection]
}

struct RecipeInfoUseCase: RecipeInfoUseCaseType {
    let favoriteRepository = FavoriteRepository()
    let shoppingListRepository = ShoppingListRepository()
    
    func getRecipe(id: Int) -> Observable<RecipeInformation> {
        // TODO: Add API
        return Observable.just(RecipeInformation())
    }
    
    func addToShopingList(recipe: RecipeInformation, type: RecipeType) -> Observable<Void> {
        var recipe = recipe
        recipe.id = type.id
        recipe.title = type.title
        return shoppingListRepository.add(ShoppingList(from: recipe))
    }
    
    func addToShopingList(recipe: RecipeInformation) -> Observable<Void> {
        return shoppingListRepository.add([ShoppingList(from: recipe)])
    }
    
    func updateFavorite(recipe: RecipeType, status: Bool) -> Observable<Void> {
        let repository = FavoriteRepository()
        if status {
            return repository.add([FavoriteRecipe(from: recipe)])
        } else {
            return repository.deleteItem(havingID: recipe.id)
        }
    }
    
    func checkFavorite(recipe: RecipeType) -> Observable<Bool> {
        let repository = FavoriteRepository()
        return repository.item(havingID: recipe.id).map { $0 != nil }
    }
    
    func checkShoping(recipe: RecipeType) -> Observable<Bool> {
        return shoppingListRepository.item(havingID: recipe.id).map { $0 != nil }
    }
    
    func getDataSource(index: Int, from recipe: RecipeInformation) -> [RecipeTableViewSection] {
        switch index {
        case 0:
            return [RecipeTableViewSection.nutrientSection(item: recipe)]
        case 1:
            return [RecipeTableViewSection.ingredientSection(item: recipe)]
        default:
            return recipe.analyzedInstructions.map { RecipeTableViewSection.stepSection(item: $0) }
        }
    }
}
