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

    }

    struct Output {

    }

    func transform(_ input: Input) -> Output {
        return Output()
    }
}
