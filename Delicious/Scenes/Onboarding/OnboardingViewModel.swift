//
//  OnboardingViewModel.swift
//  Delicious
//
//  Created by HoaPQ on 8/6/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

struct OnboardingModel {
    let image: UIImage
    let title: String
    let content: String
}

struct OnboardingViewModel {
    let navigator: OnboardingNavigatorType
    let useCase: OnboardingUseCaseType
}

extension OnboardingViewModel: ViewModelType {
    
    struct Input {
        let loadTrigger: Driver<Void>
        let nextTrigger: Driver<Void>
        let pageChangeTrigger: Driver<Int>
    }
    
    struct Output {
        let models: Driver<[OnboardingModel]>
        let index: Driver<Int>
        let buttonTitle: Driver<String>
        let selected: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let models = input.loadTrigger
            .map(useCase.getOnboardingModels)
        
        let index = input.nextTrigger
            .withLatestFrom(input.pageChangeTrigger)
            .map { $0 + 1 }
        
        let buttonTitle = input.pageChangeTrigger
            .withLatestFrom(models) { page, models -> String in
                return page >= models.count - 1 ? "Done" : "Next"
            }
        
        let selected = index
            .withLatestFrom(models) { index, models in
                return index == models.count
            }
            .filter { $0 }
            .mapToVoid()
            .do(onNext: self.navigator.toMain)
        
        return Output(
            models: models,
            index: Driver.merge(Driver.just(0), index),
            buttonTitle: buttonTitle,
            selected: selected
        )
    }
}
