//
//  Number+.swift
//  Delicious
//
//  Created by HoaPQ on 7/30/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

extension Int {
    var servingsText: String {
        return String(format: "%d people", self)
    }
    
    var cookTimeText: String {
        return String(format: "%d minutes", self)
    }
    
    var timeToDificulty: String {
        switch self {
        case 0..<20:
            return "Easy"
        case 20...40:
            return "Medium"
        default:
            return "Hard"
        }
    }
}
