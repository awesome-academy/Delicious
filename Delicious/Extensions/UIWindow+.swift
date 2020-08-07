//
//  UIWindow+.swift
//  Delicious
//
//  Created by HoaPQ on 8/6/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

extension UIWindow {
    func switchRootViewController(_ viewController: UIViewController,
                                  animated: Bool = true,
                                  duration: TimeInterval = 0.3,
                                  options: UIView.AnimationOptions = .transitionCrossDissolve,
                                  completion: (() -> Void)? = nil) {
        guard animated else {
            rootViewController = viewController
            return
        }
        UIView.transition(with: self,
                          duration: duration,
                          options: options,
                          animations: {
                              let oldState = UIView.areAnimationsEnabled
                              UIView.setAnimationsEnabled(false)
                              self.rootViewController = viewController
                              UIView.setAnimationsEnabled(oldState)
                          }, completion: { _ in
                              completion?()
                          })
    }
}
