//
//  StepTBCell.swift
//  Delicious
//
//  Created by HoaPQ on 7/9/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

final class StepTBCell: UITableViewCell, NibReusable {

    @IBOutlet private weak var stepLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setUp(data: Step) {
        stepLabel.text = "\(data.number)"
        contentLabel.text = data.step
    }
    
}
