//
//  SearchViewModel.swift
//  Delicious
//
//  Created by HoaPQ on 7/31/20.
//  Copyright © 2020 sun. All rights reserved.
//

struct SearchViewModel {
    let navigator: SearchNavigatorType
    let useCase: SearchUseCaseType
}

// MARK: - ViewModelType
extension SearchViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
    }

    struct Output {
        let tags: Driver<[SearchCollectionViewSection]>
    }

    func transform(_ input: Input) -> Output {
        let tags = input.loadTrigger
            .map {
                self.useCase.getSearchTags()
            }
        return Output(
            tags: tags
        )
    }
}
