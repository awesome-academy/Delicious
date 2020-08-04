//
//  NSShortIngredient.swift
//  Delicious
//
//  Created by HoaPQ on 8/4/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation
import RxDataSources

public class NSShortIngredient: NSObject, NSCoding {
    let id: Int
    let title: String
    let amount: Double
    let unit: String
    var isDone = false

    init(id: Int, title: String, amount: Double, unit: String, isDone: Bool) {
        self.id = id
        self.title = title
        self.amount = amount
        self.unit = unit
        self.isDone = isDone
    }

    init(from ingredient: ExtendedIngredient) {
        id = ingredient.id
        title = ingredient.name
        amount = ingredient.amount
        unit = ingredient.unit
        isDone = false
    }

    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(title, forKey: "title")
        coder.encode(amount, forKey: "amount")
        coder.encode(unit, forKey: "unit")
        coder.encode(isDone, forKey: "isDone")
    }

    public required init?(coder: NSCoder) {
        id = coder.decodeInteger(forKey: "id")
        title = coder.decodeObject(forKey: "title") as? String ?? ""
        amount = coder.decodeDouble(forKey: "amount")
        unit = coder.decodeObject(forKey: "unit") as? String ?? ""
        isDone = coder.decodeBool(forKey: "isDone")
    }

    func toStruct() -> ShortIngredient {
        return ShortIngredient(
            id: id,
            title: title,
            amount: amount,
            unit: unit,
            isDone: isDone
        )
    }
}
