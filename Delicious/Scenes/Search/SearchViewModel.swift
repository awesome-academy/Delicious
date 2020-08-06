//
//  SearchViewModel.swift
//  Delicious
//
//  Created by HoaPQ on 7/31/20.
//  Copyright © 2020 sun. All rights reserved.
//

struct SearchModel {
    let query: String
    let tags: [SearchTag]
}

struct SearchViewModel {
    let navigator: SearchNavigatorType
    let useCase: SearchUseCaseType
}

// MARK: - ViewModelType
extension SearchViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let searchTrigger: Driver<String>
        let tagTrigger: Driver<SearchTag>
        let reloadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        let autoCompletion: Driver<String>
        let selectTrigger: Driver<RecipeType>
    }

    struct Output {
        let tags: Driver<[SearchCollectionViewSection]>
        let results: Driver<[SearchResultSection]>
        let autoCompletions: Driver<[AutoCompletionSection]>
        let selected: Driver<Void>
        let searched: Driver<Void>
        let isLoading: Driver<Bool>
        let isReloading: Driver<Bool>
        let isLoadmore: Driver<Bool>
        let state: Driver<EmptyView.State>
    }

    func transform(_ input: Input) -> Output {
        let tags = input.loadTrigger
            .map {
                self.useCase.getSearchTags()
            }
        let searchModel = Driver.merge(
            input.searchTrigger.map { SearchModel(query: $0, tags: []) },
            input.tagTrigger.map { SearchModel(query: "", tags: [$0]) }
        )

        let reloadTrigger = input.reloadTrigger.withLatestFrom(searchModel)
        let loadMoreTrigger = input.loadMoreTrigger.withLatestFrom(searchModel)

        let getSearch = getPage(
            loadTrigger: searchModel,
            reloadTrigger: reloadTrigger,
            loadMoreTrigger: loadMoreTrigger
        ) { (model, page) in
            self.useCase.search(input: model, page: page)
        }

        let (page, error, isLoading, isReloading, isLoadingMore) = getSearch.destructured

        let results = page.map { data in
            self.useCase.getSearchResultSection(data: data.items)
        }

        let autoCompletion = input.autoCompletion
            .filter { !$0.isEmpty }
            .flatMapLatest { query in
                return self.useCase.getAutoCompletion(text: query).asDriver(onErrorJustReturn: [])
            }.map {
                return self.useCase.setSuggestSection(texts: $0.map { $0.title })
            }

        let selected = input.selectTrigger
            .do(onNext: self.navigator.toInformation(recipe:))
            .mapToVoid()

        let searchState = results.map { $0.isEmpty ? EmptyView.State.empty(Constant.emptyMessage) : .normal }

        let state = Driver.merge(
            searchState,
            error.map { EmptyView.State.error($0) }
        )

        let searched = searchModel.mapToVoid()

        return Output(
            tags: tags,
            results: results,
            autoCompletions: autoCompletion,
            selected: selected,
            searched: searched,
            isLoading: isLoading,
            isReloading: isReloading,
            isLoadmore: isLoadingMore,
            state: state
        )
    }
}
