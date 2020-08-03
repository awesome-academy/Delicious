//
//  HomeViewModel.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 sun. All rights reserved.
//

struct HomeViewModel {
    let navigator: HomeNavigatorType
    let useCase: HomeUseCaseType
}

// MARK: - ViewModelType
extension HomeViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let selectTrigger: Driver<RecipeType>
        let selectItemTrigger: Driver<HomeTableViewItem>
        let searchTrigger: Driver<Void>
    }

    struct Output {
        let data: Driver<[HomeTableViewSection]>
        let isLoading: Driver<Bool>
        let isReloading: Driver<Bool>
        let tableViewState: Driver<EmptyView.State>
        let loadedError: Driver<Error>
        let selected: Driver<Void>
        let search: Driver<Void>
    }

    func transform(_ input: HomeViewModel.Input) -> HomeViewModel.Output {
        let error = ErrorTracker()

        let getRecipes = getItem(
            loadTrigger: input.loadTrigger,
            reloadTrigger: input.reloadTrigger) { _ in
            return self.useCase.getRecipes().trackError(error)
        }

        let recipe = getRecipes.item
            .map { recipes -> [HomeTableViewSection] in
                if recipes.isEmpty { return [] }
                let data = recipes.split()
                let featuredSection = HomeTableViewSection.featuredSection(
                    item: .featuredItem(items: data.left)
                )
                let lastestSection = HomeTableViewSection.latestSection(
                    items: data.right.map { HomeTableViewItem.latestItem(item: $0) }
                )
                return [featuredSection, lastestSection]
            }

        let loadedError = error.withLatestFrom(recipe) { error, _ in error }
        
        let state = Driver.merge(
            error.map { EmptyView.State.error($0) },
            recipe.map { $0.isEmpty ? EmptyView.State.empty(Constant.emptyMessage) : .normal }
        ).distinctUntilChanged { (latest, new) in
            switch latest {
            case .error:
                return false
            default:
                switch new {
                case .error:
                    return true
                default:
                    return false
                }
            }
        }

        let selected = input.selectTrigger
            .do(onNext: { self.navigator.toInfomation(recipe: $0) })
            .mapToVoid()
        
        let selectedItem = input.selectItemTrigger
            .compactMap { item -> RecipeType? in
                switch item {
                case .latestItem(let recipe):
                    return recipe
                default:
                    return nil
                }
            }
            .do(onNext: self.navigator.toInfomation)
            .mapToVoid()

        let search = input.searchTrigger
            .do(onNext: self.navigator.toSearch)
            .mapToVoid()

        return Output(
            data: recipe,
            isLoading: getRecipes.isLoading,
            isReloading: getRecipes.isReloading,
            tableViewState: state,
            loadedError: loadedError,
            selected: Driver.merge(selected, selectedItem),
            search: search
        )
    }
}
