//
//  SuggestTableViewCell.swift
//  Delicious
//
//  Created by HoaPQ on 8/5/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

final class SuggestTableViewCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var suggestLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(_ text: String) {
        suggestLabel.text = text
    }
    
}
