//
//  HomeDataSource.swift
//  Delicious
//
//  Created by HoaPQ on 7/29/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import RxDataSources

enum HomeTableViewItem {
    case featuredItem(items: [RecipeType])
    case latestItem(item: RecipeType)
}

enum HomeTableViewSection {
    case featuredSection(item: HomeTableViewItem)
    case latestSection(items: [HomeTableViewItem])
}

extension HomeTableViewSection: SectionModelType {
    typealias Item = HomeTableViewItem

    var header: String {
        switch self {
        case .featuredSection:
            return "Featured"
        case .latestSection:
            return "Latest"
        }
    }
    
    var items: [HomeTableViewItem] {
        switch self {
        case .featuredSection(let item):
            return [item]
        case .latestSection(let items):
            return items
        }
    }
    
    init(original: Self, items: [Self.Item]) {
        self = original
    }
}
