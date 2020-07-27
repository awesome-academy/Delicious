//
//  AppNavigationController.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

final class AppNavigationController: UINavigationController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        delegate = self
        changeBackIcon()
        changeNavigationColor()
    }
    
    func changeBackIcon() {
        let barAppearance =
            UINavigationBar.appearance(whenContainedInInstancesOf: [AppNavigationController.self])
        barAppearance.do {
            $0.backIndicatorImage = Icon.icBack
            $0.backIndicatorTransitionMaskImage = Icon.icBack
            $0.tintColor = .white
            $0.shadowImage = UIImage()
        }
    }

    func changeNavigationColor() {
        navigationBar.do {
            $0.titleTextAttributes = [
                .font: UIFont.avenirBookFont(size: Constant.titleFontSize),
                .foregroundColor: UIColor.white
            ]
            $0.barTintColor = .systemOrange
        }
    }
}

extension AppNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
    }
}
