//
//  SearchDataSource.swift
//  Delicious
//
//  Created by HoaPQ on 8/5/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import RxDataSources

typealias SearchCollectionViewSection = SectionModel<String, SearchTag>
typealias AutoCompletionSection = SectionModel<String, String>

enum SearchResultItem {
    case recipe(RecipeType)
    case tags([SearchTag])
}

enum SearchResultSection {
    case result(recipes: [SearchResultItem])
    case tags(tags: [SearchResultItem])
}

extension SearchResultSection: SectionModelType {
    
    var header: String {
        return ""
    }
    
    var items: [SearchResultItem] {
        switch self {
        case .result(let recipes):
            return recipes
        case .tags(let tags):
            return tags
        }
    }
    
    init(original: Self, items: [SearchResultItem]) {
        self = original
    }
}
