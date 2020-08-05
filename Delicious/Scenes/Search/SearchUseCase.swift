//
//  SearchUseCase.swift
//  Delicious
//
//  Created by HoaPQ on 7/31/20.
//  Copyright © 2020 sun. All rights reserved.
//

protocol SearchUseCaseType {
    func getSearchTags() -> [SearchCollectionViewSection]
}

struct SearchUseCase: SearchUseCaseType {
    func getSearchTags() -> [SearchCollectionViewSection] {
        return [
            SearchCollectionViewSection.tagSection(
                items: SearchTag.allCuisines.map { SearchCollectionViewItem.tag(item: $0) }
            ),
            SearchCollectionViewSection.tagSection(
                items: SearchTag.allTypes.map { SearchCollectionViewItem.tag(item: $0) }
            ),
            SearchCollectionViewSection.tagSection(
                items: SearchTag.allDiets.map { SearchCollectionViewItem.tag(item: $0) }
            )
        ]
    }
}
