//
//  IngredientTBCell.swift
//  Delicious
//
//  Created by HoaPQ on 7/9/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

final class IngredientTBCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var ingredientLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUp(data: ExtendedIngredient) {
        ingredientLabel.text = data.originalString
    }
}
