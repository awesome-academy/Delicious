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
}
