//
//  String+.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

extension String {
    func textSize(font: UIFont?, collectionView: UICollectionView) -> CGSize {
        var frame = collectionView.bounds
        frame.size.height = 9999.0
        let label = UILabel().then {
            $0.numberOfLines = 0
            $0.text = self
            $0.font = font
        }
        var size = label.sizeThatFits(frame.size)
        size.height = min(40, size.height)
        return size
    }
}
