//
//  RecipeDataSource.swift
//  Delicious
//
//  Created by HoaPQ on 7/13/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import RxDataSources

enum RecipeTableViewItem {
    case nutrientItem(item: Nutrient)
    case ingredientItem(item: ExtendedIngredient)
    case stepItem(item: Step)
}

enum RecipeTableViewSection {
    case nutrientSection(item: RecipeInformation)
    case ingredientSection(item: RecipeInformation)
    case stepSection(item: AnalyzedInstruction)
}

extension RecipeTableViewSection: SectionModelType {
    typealias Item = RecipeTableViewItem

    var header: String {
        return ""
    }
    
    var items: [RecipeTableViewItem] {
        switch self {
        case .nutrientSection(let recipe):
            return recipe.nutrition
                         .nutrients
                         .map { RecipeTableViewItem.nutrientItem(item: $0) }
        case .ingredientSection(let recipe):
            return recipe.extendedIngredients
                         .map { RecipeTableViewItem.ingredientItem(item: $0) }
        case .stepSection(let item):
            return item.steps
                       .map { RecipeTableViewItem.stepItem(item: $0) }
        }
    }
    
    init(original: Self, items: [Self.Item]) {
        self = original
    }
}
