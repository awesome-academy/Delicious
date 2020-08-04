//
//  RecipeHeaderView.swift
//  Delicious
//
//  Created by HoaPQ on 7/13/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

final class RecipeHeaderView: UIView, NibOwnerLoadable {
    
    @IBOutlet private weak var creditsLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var difficultyLabel: UILabel!
    @IBOutlet private weak var servingsLabel: UILabel!
    @IBOutlet private weak var recipeImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNibContent()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var recipe: Binder<RecipeType> {
        return Binder(self) { (view, data) in
            view.do {
                $0.creditsLabel.text = data.creditsText
                $0.titleLabel.text = data.title
                $0.recipeImage.sd_setImage(with: URL(string: data.image),
                                           placeholderImage: Icon.recipePlaceHolder,
                                           context: nil)
                $0.timeLabel.text = data.readyInMinutes.cookTimeText
                $0.difficultyLabel.text = data.readyInMinutes.timeToDificulty
                $0.servingsLabel.text = data.servings.servingsText
            }
        }
    }
}
