//
//  FeaturedCLCell.swift
//  Delicious
//
//  Created by HoaPQ on 7/8/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit
import Reusable

final class FeaturedCLCell: UICollectionViewCell, NibReusable {

    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.applyCornerRadius()
    }
    
    func setInfo(with recipe: RecipeType) {
        imageView.sd_setImage(with: URL(string: recipe.image),
                              placeholderImage: Icon.recipePlaceHolder,
                              context: nil)
    }
}
