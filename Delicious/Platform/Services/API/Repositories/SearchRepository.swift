//
//  SearchRepository.swift
//  Delicious
//
//  Created by HoaPQ on 8/5/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

protocol SearchRepositoryType {
    func search(input: SearchRequest) -> Observable<PagingInfo<RecipeInformation>>
    func autoCompletion(input: AutoCompletionRequest) -> Observable<[AutoCompletion]>
}

struct SearchRepository: SearchRepositoryType {
    private let api = APIService.shared
    func search(input: SearchRequest) -> Observable<PagingInfo<RecipeInformation>> {
        return api.request(input: input).map { (response: SearchResponse) in
            let page = response.offset / response.number + 1
            let pagingInfo = PagingInfo<RecipeInformation>(
                page: page,
                items: response.results,
                hasMorePages: response.results.count >= Constant.numberPerPage
            )
            return pagingInfo
        }
    }
    
    func autoCompletion(input: AutoCompletionRequest) -> Observable<[AutoCompletion]> {
        return api.request(input: input)
    }
}
