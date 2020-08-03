//
//  HeaderTableView.swift
//  Delicious
//
//  Created by HoaPQ on 8/3/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class HeaderTableView: UITableView {
    
    var minHeaderHeight: CGFloat = 0
    
    private lazy var maxContentHeight: CGFloat = self.height + 88
    private let extraBottomInset = (Helpers.safeAreaInsets?.bottom ?? 0) + 80
    
    override var contentSize: CGSize {
        didSet {
            let currentHeight = contentSize.height
            maxContentHeight = min(max(maxContentHeight, currentHeight), height + 88)
            if currentHeight < maxContentHeight {
                let insetBottom = maxContentHeight - currentHeight + extraBottomInset
                contentInset = UIEdgeInsets(top: contentInset.top,
                                            left: 0,
                                            bottom: insetBottom,
                                            right: 0)
            } else {
                contentInset = UIEdgeInsets(top: contentInset.top,
                                            left: 0,
                                            bottom: extraBottomInset,
                                            right: 0)
            }
        }
    }
}
