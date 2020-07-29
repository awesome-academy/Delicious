//
//  RecipeType.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

protocol RecipeType {
    var id: Int { get set }
    var title: String { get set }
    var readyInMinutes: Int { get set }
    var servings: Int { get set }
    var image: String { get set }
    var creditsText: String { get set }
}
