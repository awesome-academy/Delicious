//
//  FavoriteViewModel.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 sun. All rights reserved.
//

typealias RecipeListSectionModel = AnimatableSectionModel<String, FavoriteRecipe>

struct FavoriteViewModel {
    let navigator: FavoriteNavigatorType
    let useCase: FavoriteUseCaseType
}

// MARK: - ViewModelType
extension FavoriteViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let selectTrigger: Driver<FavoriteRecipe>
        let deleteTrigger: Driver<FavoriteRecipe>
    }

    struct Output {
        let data: Driver<[RecipeListSectionModel]>
        let state: Driver<EmptyView.State>
        let error: Driver<Error>
        let isLoading: Driver<Bool>
        let isReloading: Driver<Bool>
        let selected: Driver<Void>
        let deleted: Driver<Void>
    }

    func transform(_ input: Input) -> Output {
        let error = ErrorTracker()
        let getRecipes = getItem(
            loadTrigger: input.loadTrigger,
            reloadTrigger: input.reloadTrigger) {
            self.useCase
                .getFavoriteRecipes()
                .trackError(error)
        }
        
        let (item, _, isLoading, isReloading) = getRecipes.destructured
        
        let data = item.map { $0.isEmpty ? [] : [RecipeListSectionModel(model: "", items: $0)] }
        let state = data.map { $0.isEmpty ? EmptyView.State.empty(Constant.emptyMessage) : .normal }
        
        let selected = input.selectTrigger
            .do(onNext: self.navigator.toInfomation)
            .mapToVoid()
        
        let deleted = input.deleteTrigger
            .flatMapLatest {
                self.navigator
                    .showDeletionConfirm(recipe: $0)
            }
            .flatMapLatest {
                self.useCase
                    .remove(recipe: $0)
                    .trackError(error)
                    .asDriverOnErrorJustComplete()
            }
        
        return Output(
            data: data,
            state: state,
            error: error.asDriver(),
            isLoading: isLoading,
            isReloading: isReloading,
            selected: selected,
            deleted: deleted
        )
    }
}
