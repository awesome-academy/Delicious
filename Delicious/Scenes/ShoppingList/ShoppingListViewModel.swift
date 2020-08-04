//
//  ShoppingListViewModel.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 sun. All rights reserved.
//

typealias ShoppingListSectionModel = SectionModel<ShoppingList, ShortIngredient>

struct ShoppingListViewModel {
    let navigator: ShoppingListNavigatorType
    let useCase: ShoppingListUseCaseType
}

// MARK: - ViewModelType
extension ShoppingListViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let selectTrigger: Driver<IndexPath>
        let selectTitleTrigger: Driver<RecipeType>
        let deleteTrigger: Driver<ShoppingList>
    }
    
    struct Output {
        let data: Driver<[ShoppingListSectionModel]>
        let state: Driver<EmptyView.State>
        let isLoading: Driver<Bool>
        let isReloading: Driver<Bool>
        let error: Driver<Error>
        let selected: Driver<Void>
        let selectedTitle: Driver<Void>
        let deleted: Driver<Void>
    }
    
    func transform(_ input: ShoppingListViewModel.Input) -> ShoppingListViewModel.Output {
        
        let error = ErrorTracker()

        let getLists = getItem(
            loadTrigger: input.loadTrigger,
            reloadTrigger: input.reloadTrigger) { _ in
                return self.useCase
                    .getShopingListRecipes()
                    .trackError(error)
        }
        let lists = getLists.item.map { list in
            list.map { ShoppingListSectionModel(model: $0, items: $0.ingredients) }
        }
        
        let state = lists.map { $0.isEmpty ? EmptyView.State.empty(Constant.shoppingEmptyMessage) : .normal }
        
        let selected = input.selectTrigger
            .withLatestFrom(getLists.item) { (index, lists) -> (Int, ShoppingList) in
                return (index.row, lists[index.section])
            }.flatMapLatest { (index, list) -> Driver<Void> in
                var list = list
                var ingredients = list.ingredients
                let isDone = list.ingredients[index].isDone
                ingredients[index].isDone = !isDone
                list.ingredients = ingredients
                return self.useCase.update(list: list).asDriverOnErrorJustComplete()
            }
        
        let selectedTitle = input.selectTitleTrigger
            .do(onNext: self.navigator.toInformation)
            .mapToVoid()
        
        let deleted = input.deleteTrigger
            .flatMapLatest(self.navigator.showDeletionConfirm)
            .flatMapLatest {
                self.useCase
                    .remove(list: $0)
                    .trackError(error)
                    .asDriverOnErrorJustComplete()
            }
        
        return Output(
            data: lists,
            state: state,
            isLoading: getLists.isLoading,
            isReloading: getLists.isReloading,
            error: error.asDriver(),
            selected: selected,
            selectedTitle: selectedTitle,
            deleted: deleted
        )
    }
}
