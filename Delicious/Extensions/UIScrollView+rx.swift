//
//  UIScrollView+rx.swift
//  Delicious
//
//  Created by HoaPQ on 8/6/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

extension Reactive where Base: UIScrollView {
    var currentPage: ControlProperty<Int> {
        let source = didScroll.map { _ -> Int in
            let pageWidth = self.base.frame.width
            let page = floor((self.base.contentOffset.x - pageWidth / 2) / pageWidth) + 1
            return Int(page)
        }.distinctUntilChanged()
        
        let observer = Binder(base) { (scrollView, newPage: Int) in
            let rect = scrollView.bounds.with {
                $0.origin.x = $0.width * CGFloat(newPage)
                $0.origin.y = 0
            }
            scrollView.scrollRectToVisible(rect, animated: true)
        }
        return ControlProperty<Int>(values: source, valueSink: observer)
    }
}
