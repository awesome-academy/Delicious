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

    }

    struct Output {

    }

    func transform(_ input: Input) -> Output {
        return Output()
    }
}
