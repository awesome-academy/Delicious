//
//  FeaturedTBCell.swift
//  Delicious
//
//  Created by HoaPQ on 7/29/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit
import Reusable
import RxSwift
import RxCocoa
import RxDataSources

final class FeaturedTBCell: UITableViewCell, NibReusable {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let cellHeight: CGFloat = 160
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCollectionView()
    }
    
    private func configCollectionView() {
        collectionView.do {
            $0.register(cellType: FeaturedCLCell.self)
        }
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        collectionView.do {
            $0.delegate = dataSourceDelegate
            $0.dataSource = dataSourceDelegate
            $0.tag = row
            $0.reloadData()
        }
    }
}
