//
//  Helpers.swift
//  Delicious
//
//  Created by HoaPQ on 7/29/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

enum Helpers {
    static var statusBarSize: CGSize?
    static var safeAreaInsets: UIEdgeInsets?
    static var hasRunBefore: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constant.kFirstRun)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constant.kFirstRun)
        }
    }
}
