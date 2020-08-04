//
//  ShoppingListHeaderView.swift
//  Delicious
//
//  Created by HoaPQ on 8/4/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

final class ShoppingListHeaderView: UIView, NibLoadable {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var removeImage: UIImageView!
    
    var tapTitle: ((RecipeType) -> Void)?
    var tapRemove: ((ShoppingList) -> Void)?
    private var data: ShoppingList?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.addTapGesture(target: self, action: #selector(onTitleTap))
        removeImage.addTapGesture(target: self, action: #selector(onRemoveTap))
    }
    
    func setUp(recipe: ShoppingList) {
        data = recipe
        titleLabel.text = recipe.title
    }
    
    @objc private func onTitleTap() {
        guard let data = data else { return }
        tapTitle?(data)
    }
    
    @objc private func onRemoveTap() {
        guard let data = data else { return }
        tapRemove?(data)
    }
}
