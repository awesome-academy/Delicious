//
//  HomeTableHeaderView.swift
//  FLAVR
//
//  Created by HoaPQ on 7/29/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit
import Reusable

final class HomeTableHeaderView: UIView, NibLoadable {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    func setUp(title: String) {
        headerLabel.text = title
    }

}
