//
//  Array+.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

extension Array {
    func split(from index: Int = -1) -> (left: [Element], right: [Element]) {
        let splitIndex = index < 0 || index >= count ? count / 2 : index
        let leftSplit = self[0 ..< splitIndex]
        let rightSplit = self[splitIndex ..< count]
        return (left: Array(leftSplit), right: Array(rightSplit))
    }
}
