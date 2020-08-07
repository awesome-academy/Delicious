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
        let selectTrigger: Driver<SearchResultItem>
        let removeTagTrigger: Driver<SearchTag>
    }

    struct Output {
        let tags: Driver<[SearchCollectionViewSection]>
        let results: Driver<[SearchResultSection]>
        let autoCompletions: Driver<[AutoCompletionSection]>
        let selected: Driver<Void>
        let isLoading: Driver<Bool>
        let isReloading: Driver<Bool>
        let isLoadmore: Driver<Bool>
        let hasMorePage: Driver<Bool>
        let state: Driver<EmptyView.State>
        let showResults: Driver<Void>
        let showTags: Driver<Void>
        let showAutoCompletion: Driver<Void>
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
        
        let removeTag = input.removeTagTrigger
            .withLatestFrom(searchModel) { tag, model  -> SearchModel in
                var newTags = model.tags
                if let index = newTags.firstIndex(where: { $0 == tag }) {
                    newTags.remove(at: index)
                }
                return SearchModel(query: model.query, tags: newTags)
            }
        
        let newSearchModel = Driver.merge(searchModel, removeTag)

        let reloadTrigger = input.reloadTrigger.withLatestFrom(newSearchModel)
        let loadMoreTrigger = input.loadMoreTrigger.withLatestFrom(newSearchModel)

        let getSearch = getPage(
            loadTrigger: searchModel,
            reloadTrigger: reloadTrigger,
            loadMoreTrigger: loadMoreTrigger
        ) { (model, page) in
            self.useCase.search(input: model, page: page)
        }

        let (page, error, isLoading, isReloading, isLoadingMore) = getSearch.destructured

        let results = page
            .withLatestFrom(searchModel) { (page, model) in
                self.useCase.getSearchResultSection(data: page.items, tags: model.tags)
            }
        let hasMorePage = page.map { $0.hasMorePages }

        let autoCompletion = input.autoCompletion
            .filter { !$0.isEmpty }
            .flatMapLatest { query in
                return self.useCase.getAutoCompletion(text: query).asDriver(onErrorJustReturn: [])
            }.map {
                return self.useCase.setSuggestSection(texts: $0.map { $0.title })
            }

        let selected = input.selectTrigger
            .do(onNext: { item in
                switch item {
                case .recipe(let recipe):
                    self.navigator.toInformation(recipe: recipe)
                default:
                    break
                }
            })
            .mapToVoid()

        let searchState = results.map { $0.isEmpty ? EmptyView.State.empty(Constant.emptyMessage) : .normal }

        let state = Driver.merge(
            searchState,
            error.map { EmptyView.State.error($0) }
        )
        
        let showResults = Driver.merge(
            input.searchTrigger.mapToVoid(),
            input.tagTrigger.mapToVoid()
        )
        
        let showTags = Driver.merge(
            input.autoCompletion
                .filter { $0.isEmpty }
                .mapToVoid(),
            newSearchModel
                .filter { $0.query.isEmpty && $0.tags.isEmpty }
                .mapToVoid()
        )
        
        let showAutoCompletion = input.autoCompletion
            .filter { !$0.isEmpty }
            .mapToVoid()

        return Output(
            tags: tags,
            results: results,
            autoCompletions: autoCompletion,
            selected: selected,
            isLoading: isLoading,
            isReloading: isReloading,
            isLoadmore: isLoadingMore,
            hasMorePage: hasMorePage,
            state: state,
            showResults: showResults,
            showTags: showTags,
            showAutoCompletion: showAutoCompletion
        )
    }
}
