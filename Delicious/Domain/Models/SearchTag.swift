//
//  SearchTag.swift
//  Delicious
//
//  Created by HoaPQ on 8/5/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

enum SearchTag {
    case recent(String)
    case type(String)
    case cuisine(String)
    case diet(String)
    
    var textString: String {
        switch self {
        case .cuisine(let text):
            return text
        case .type(let text):
            return text
        case .recent(let text):
            return text
        case .diet(let text):
            return text
        }
    }
    
    var typeString: String {
        switch self {
        case .recent:
            return "Recent"
        case .type:
            return "Meal Types"
        case .cuisine:
            return "Cuisines"
        case .diet:
            return "Diets"
        }
    }
    
    static var allTypes: [SearchTag] {
        return Constant.mealTypes.map { SearchTag.type($0) }
    }
    static var allDiets: [SearchTag] {
        return Constant.diets.map { SearchTag.diet($0)}
    }
    static var allCuisines: [SearchTag] {
        return Constant.cuisines.map { SearchTag.cuisine($0) }
    }
}
