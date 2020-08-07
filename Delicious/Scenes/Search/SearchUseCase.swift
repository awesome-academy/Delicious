//
//  SearchUseCase.swift
//  Delicious
//
//  Created by HoaPQ on 7/31/20.
//  Copyright © 2020 sun. All rights reserved.
//

protocol SearchUseCaseType {
    func search(input: SearchModel, page: Int) -> Observable<PagingInfo<RecipeInformation>>
    func getAutoCompletion(text: String) -> Observable<[AutoCompletion]>
    func setSuggestSection(texts: [String]) -> [AutoCompletionSection]
    func getSearchResultSection(data: [RecipeInformation], tags: [SearchTag]) -> [SearchResultSection]
    func getSearchTags() -> [SearchCollectionViewSection]
}

struct SearchUseCase: SearchUseCaseType {
    let repository = SearchRepository()
    func search(input: SearchModel, page: Int) -> Observable<PagingInfo<RecipeInformation>> {
        let offset = (page - 1) * Constant.numberPerPage
        let request = SearchRequest(query: input.query, tags: input.tags, offset: offset)
        return repository.search(input: request)
    }
    
    func getAutoCompletion(text: String) -> Observable<[AutoCompletion]> {
        let input = AutoCompletionRequest(query: text)
        return repository.autoCompletion(input: input)
    }
    
    func setSuggestSection(texts: [String]) -> [AutoCompletionSection] {
        return [
            AutoCompletionSection(model: "", items: texts)
        ]
    }
    
    func getSearchResultSection(data: [RecipeInformation], tags: [SearchTag]) -> [SearchResultSection] {
        if data.isEmpty { return [] }
        var sections = [
            SearchResultSection.result(recipes: data.map { SearchResultItem.recipe($0) })
        ]
        if !tags.isEmpty {
            sections.insert(SearchResultSection.tags(tags: [SearchResultItem.tags(tags)]), at: 0)
        }
        return sections
    }
    func getSearchTags() -> [SearchCollectionViewSection] {
        return [
            SearchCollectionViewSection(model: "", items: SearchTag.allCuisines),
            SearchCollectionViewSection(model: "", items: SearchTag.allTypes),
            SearchCollectionViewSection(model: "", items: SearchTag.allDiets)
        ]
    }
}
