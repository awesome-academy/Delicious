//
//  ShortIngredient.swift
//  Delicious
//
//  Created by HoaPQ on 7/15/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation
import RxDataSources

struct ShortIngredient {
    let id: Int
    let title: String
    let amount: Double
    let unit: String
    var isDone = false
}

extension ShortIngredient {
    init(from ingredient: ExtendedIngredient) {
        id = ingredient.id
        title = ingredient.name
        amount = ingredient.amount
        unit = ingredient.unit
        isDone = false
    }
    
    func toClass() -> NSShortIngredient {
        return NSShortIngredient(
            id: id,
            title: title,
            amount: amount,
            unit: unit,
            isDone: isDone
        )
    }
}
