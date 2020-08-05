//
//  SearchDataSource.swift
//  Delicious
//
//  Created by HoaPQ on 8/5/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import RxDataSources

enum SearchCollectionViewItem {
    case tag(item: SearchTag)
}

enum SearchCollectionViewSection {
    case tagSection(items: [SearchCollectionViewItem])
}

extension SearchCollectionViewSection: SectionModelType {
    typealias Item = SearchCollectionViewItem
    
    var header: String {
        return ""
    }
    var items: [SearchCollectionViewItem] {
        switch self {
        case .tagSection(let tags):
            return tags
        }
    }
    
    init(original: Self, items: [Self.Item]) {
        self = original
    }
}

enum SearchTableViewItem {
    case result(item: RecipeType)
    case suggest(item: String)
}

enum SearchTableViewSection {
    case resultSection(items: [SearchTableViewItem])
    case suggestSection(items: [SearchTableViewItem])
}

extension SearchTableViewSection: SectionModelType {
    typealias Item = SearchTableViewItem
    
    var header: String {
        return ""
    }
    var items: [SearchTableViewItem] {
        switch self {
        case .resultSection(let recipes):
            return recipes
        case .suggestSection(let texts):
            return texts
        }
    }
    
    init(original: Self, items: [Self.Item]) {
        self = original
    }
}
