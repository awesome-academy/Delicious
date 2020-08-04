//
//  ShoppingListTBCell.swift
//  Delicious
//
//  Created by HoaPQ on 8/4/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

final class ShoppingListTBCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var ingredientLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUp(short: ShortIngredient) {
        amountLabel.text = "\(short.amount) \(short.unit)"
        ingredientLabel.attributedText = short.title.capitalized.strikedThrough(short.isDone)
        layoutIfNeeded()
    }
    
}
