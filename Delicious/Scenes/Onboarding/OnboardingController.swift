//
//  OnboardingController.swift
//  Delicious
//
//  Created by HoaPQ on 8/6/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import Foundation

final class OnboardingController: UIViewController, BindableType {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var stackView: UIStackView!
    
    // MARK: - Properties
    
    var viewModel: OnboardingViewModel!
    private var scrollWidth: CGFloat = 0
    private var scrollHeight: CGFloat = 0
    private var models: Binder<[OnboardingModel]> {
        return Binder(self) { viewController, models in
            viewController.loadModels(models: models)
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollWidth = scrollView.width
        scrollHeight = scrollView.height
    }
    
    deinit {
        logDeinit()
    }
    
    // MARK: - Methods
    
    private func configView() {
        scrollView.do {
            $0.isPagingEnabled = true
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
        }
    }
    
    func bindViewModel() {
        let input = OnboardingViewModel.Input(
            loadTrigger: Driver.just(()),
            nextTrigger: nextButton.rx.tap.asDriver(),
            pageChangeTrigger: scrollView.rx.currentPage
                                            .asDriver()
                                            .startWith(0)
        )
        let output = viewModel.transform(input)
        output.buttonTitle
            .drive(nextButton.rx.title())
            .disposed(by: rx.disposeBag)
        output.index
            .drive(scrollView.rx.currentPage)
            .disposed(by: rx.disposeBag)
        output.models
            .drive(models)
            .disposed(by: rx.disposeBag)
        output.selected
            .drive()
            .disposed(by: rx.disposeBag)
        scrollView.rx.currentPage
            .bind(to: pageControl.rx.currentPage)
            .disposed(by: rx.disposeBag)
    }
    
    private func loadModels(models: [OnboardingModel]) {
        for model in models {
            let slide = OnboardingView().then {
                $0.setUp(model)
            }
            
            stackView.addArrangedSubview(slide)
            slide.snp.makeConstraints {
                $0.width.height.equalTo(scrollView)
            }
        }

        scrollView.contentSize.height = 1.0
        pageControl.numberOfPages = models.count
        pageControl.currentPage = 0
    }
}

// MARK: - Binders
extension OnboardingController {

}

// MARK: - StoryboardSceneBased
extension OnboardingController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoards.onboarding
}
