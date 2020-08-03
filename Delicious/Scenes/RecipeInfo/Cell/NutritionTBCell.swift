//
//  NutritionTBCell.swift
//  Delicious
//
//  Created by HoaPQ on 7/9/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

final class NutritionTBCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var dailyNeedLabel: UILabel!

    func setData(data: Nutrient) {
        nameLabel.text = data.title
        valueLabel.text = "\(data.amount)/\(data.percentOfDailyNeeds) \(data.unit)"
        dailyNeedLabel.text = ""
        if data.amount > data.percentOfDailyNeeds {
            valueLabel.textColor = .systemRed
            dailyNeedLabel.textColor = .systemGreen
        } else {
            valueLabel.textColor = .systemGreen
            dailyNeedLabel.textColor = nameLabel.textColor
        }
    }
    
}
