//
//  AppNavigator.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 sun. All rights reserved.
//

protocol AppNavigatorType {
    func toMain()
}

struct AppNavigator: AppNavigatorType {
    unowned let window: UIWindow
    
    func toMain() {
        let viewController = ViewController()
        window.rootViewController = viewController
    }
}
