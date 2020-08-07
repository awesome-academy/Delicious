//
//  AppViewModel.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 sun. All rights reserved.
//

struct AppViewModel {
    let navigator: AppNavigatorType
    let useCase: AppUseCaseType
}

// MARK: - ViewModelType
extension AppViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let toMain: Driver<Void>
    }
    
    func transform(_ input: AppViewModel.Input) -> AppViewModel.Output {
        
        let toMain = input.loadTrigger
            .do(onNext: {
                Helpers.hasRunBefore ? self.navigator.toMain() : self.navigator.toOnboarding()
                Helpers.hasRunBefore = true
            })
        
        return Output(
            toMain: toMain
        )
    }
}
