//
//  SearchCollectionViewHeader.swift
//  Delicious
//
//  Created by HoaPQ on 8/5/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

final class SearchCollectionViewHeader: UICollectionReusableView, NibReusable {

    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
