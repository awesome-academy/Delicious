//
//  AppNavigator.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 sun. All rights reserved.
//

protocol AppNavigatorType {
    func toMain()
    func toOnboarding()
}

struct AppNavigator: AppNavigatorType, Application {
    unowned let window: UIWindow
    
    func toMain() {
        window.rootViewController = mainTabbar
    }
    
    func toOnboarding() {
        let navigator = OnboardingNavigator(window: window)
        let useCase = OnboardingUseCase()
        let viewModel = OnboardingViewModel(navigator: navigator, useCase: useCase)
        let viewController = OnboardingController.instantiate().then {
            $0.bindViewModel(to: viewModel)
        }
        
        window.rootViewController = viewController
    }
}
