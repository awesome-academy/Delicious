//
//  SceneDelegate.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        Helpers.statusBarSize = windowScene.statusBarManager?.statusBarFrame.size
        Helpers.safeAreaInsets = window?.safeAreaInsets
        bindViewModel()
    }

    private func bindViewModel() {
        guard let window = window else { return }
        let navigator = AppNavigator(window: window)
        let useCase = AppUseCase()
        let viewModel = AppViewModel(navigator: navigator, useCase: useCase)

        let input = AppViewModel.Input(loadTrigger: Driver.just(()))
        let output = viewModel.transform(input)
        output.toMain
            .drive()
            .disposed(by: rx.disposeBag)
    }
}
