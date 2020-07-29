//
//  RecipeTBCell.swift
//  Delicious
//
//  Created by HoaPQ on 7/29/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit
import Reusable
import SDWebImage

final class RecipeTBCell: UITableViewCell, NibReusable {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var timeToCookLabel: UILabel!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shadowView.do {
            $0.applyCornerRadius()
            $0.applyShadowWithColor(color: .black,
                                    opacity: Constant.shadowOpacity,
                                    radius: Constant.shadowRadius)
        }
        containerView.applyCornerRadius()
    }

    func setInfo(recipe: RecipeType) {
        recipeImage.sd_setImage(with: URL(string: recipe.image),
                                placeholderImage: Icon.recipePlaceHolder,
                                context: nil)
        categoryLabel.text = recipe.creditsText
        recipeNameLabel.text = recipe.title
        timeToCookLabel.text = recipe.readyInMinutes.cookTimeText
        difficultyLabel.text = Helpers.timeToDificulty(with: recipe.readyInMinutes)
        servingLabel.text = recipe.servings.servingsText
    }
}
