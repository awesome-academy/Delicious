//
//  MBSegmentControl+Rx.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import MBSegmentControl

extension Reactive where Base: MBSegmentControl {
    public var selectedSegmentIndex: ControlProperty<Int> {
        return value
    }
    
    public var value: ControlProperty<Int> {
        return controlProperty(editingEvents: .valueChanged,
                               getter: { $0.selectedIndex },
                               setter: { $0.selectedIndex = $1 })
    }
}
