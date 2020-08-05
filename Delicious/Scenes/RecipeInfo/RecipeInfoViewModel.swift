//
//  RecipeInfoViewModel.swift
//  Delicious
//
//  Created by HoaPQ on 7/31/20.
//  Copyright © 2020 sun. All rights reserved.
//

struct RecipeInfoViewModel {
    let navigator: RecipeInfoNavigatorType
    let useCase: RecipeInfoUseCaseType
    let recipe: RecipeType
}

// MARK: - ViewModelType
extension RecipeInfoViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let favoriteTrigger: Driver<Bool>
        let segmentTrigger: Driver<Int>
        let loadShoppingListTrigger: Driver<Void>
        let addToShoppingListTrigger: Driver<Void>
    }
    
    struct Output {
        let title: Driver<String>
        let recipe: Driver<RecipeType>
        let isFavorited: Driver<Bool>
        let dataSource: Driver<[RecipeTableViewSection]>
        let shoppingButtonHidden: Driver<Bool>
        let isLoading: Driver<Bool>
        let isReloading: Driver<Bool>
        let error: Driver<Error>
        let tapShopingList: Driver<Void>
    }
    
    func transform(_ input: RecipeInfoViewModel.Input) -> RecipeInfoViewModel.Output {
        let error = ErrorTracker()
        let title = input.loadTrigger.map { _ in
            return self.recipe.title
        }
        let recipe = input.loadTrigger.map { _ in
            return self.recipe
        }
        let recipeInfo = getItem(
            loadTrigger: input.loadTrigger,
            reloadTrigger: input.reloadTrigger) { _ in
            return self.useCase.getRecipe(id: self.recipe.id).trackError(error)
        }
        let isFavorited = input.loadTrigger.flatMapLatest { _ in
            self.useCase
                .checkFavorite(recipe: self.recipe)
                .asDriverOnErrorJustComplete()
        }
        
        let favoriteTap = input.favoriteTrigger
            .flatMapLatest { status -> Driver<Bool> in
                if !status {
                    return self.navigator
                        .showDeletionConfirm(recipe: FavoriteRecipe(from: self.recipe))
                        .map { _ in false }
                } else {
                    return input.favoriteTrigger
                }
            }.flatMapLatest { status -> Driver<Bool> in
                self.useCase
                    .updateFavorite(recipe: self.recipe, status: status)
                    .trackError(error)
                    .map { return status }
                    .asDriverOnErrorJustComplete()
            }
        
        let dataSource = Driver
            .combineLatest(input.segmentTrigger, recipeInfo.item)
            .map(self.useCase.getDataSource(index: from: ))
        
        let tapShopingList = input.addToShoppingListTrigger
            .withLatestFrom(recipeInfo.item)
            .flatMapLatest {
                self.useCase
                    .addToShopingList(recipe: $0, type: self.recipe)
                    .trackError(error)
                    .asDriverOnErrorJustComplete()
            }
            .do(onNext: self.navigator.showAddedToShoppingListMessage)
            .mapToVoid()
        
        let checkShopingList = Driver
            .merge(input.loadTrigger, input.loadShoppingListTrigger)
            .flatMapLatest {
                self.useCase
                    .checkShoping(recipe: self.recipe)
                    .asDriverOnErrorJustComplete()
            }
        
        let isHidden = Driver
            .combineLatest(input.segmentTrigger, checkShopingList)
            .map { (index, status)  in
                return status || !(index == 1)
            }
        
        return Output(
            title: title,
            recipe: Driver.merge(recipeInfo.item.map { $0 as RecipeType}, recipe),
            isFavorited: Driver.merge(isFavorited, favoriteTap),
            dataSource: dataSource,
            shoppingButtonHidden: isHidden,
            isLoading: recipeInfo.isLoading,
            isReloading: recipeInfo.isReloading,
            error: error.asDriver(),
            tapShopingList: tapShopingList
        )
    }
}
