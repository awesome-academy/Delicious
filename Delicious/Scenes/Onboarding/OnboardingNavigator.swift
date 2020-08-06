//
//  OnboardingNavigator.swift
//  Delicious
//
//  Created by HoaPQ on 8/6/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

protocol OnboardingNavigatorType {
    func toMain()
}

struct OnboardingNavigator: OnboardingNavigatorType, Application {
    unowned let window: UIWindow
    
    func toMain() {
        window.switchRootViewController(mainTabbar)
    }
}
