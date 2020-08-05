//
//  RecipeInformationRepository.swift
//  Delicious
//
//  Created by HoaPQ on 8/5/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

protocol RecipeInformationRepositoryType {
    func getRecipeInfo(id: Int) -> Observable<RecipeInformation>
}

struct RecipeInformationRepository: RecipeInformationRepositoryType {
    let api = APIService.shared
    func getRecipeInfo(id: Int) -> Observable<RecipeInformation> {
        let input = RecipeInfoRequest(id: id)
        return api.request(input: input)
    }
}
