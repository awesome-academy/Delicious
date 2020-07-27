//
//  HomeViewController.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 sun. All rights reserved.
//

import UIKit
import Reusable

final class HomeViewController: UIViewController, BindableType {
    
    // MARK: - IBOutlets
    
    // MARK: - Properties
    
    var viewModel: HomeViewModel!

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    deinit {
        logDeinit()
    }
    
    // MARK: - Methods

    private func configView() {
        navigationItem.title = Constant.appTitle
    }

    func bindViewModel() {
        let input = HomeViewModel.Input()
        let output = viewModel.transform(input)
    }
}

// MARK: - Binders
extension HomeViewController {

}

// MARK: - StoryboardSceneBased
extension HomeViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoards.home
}
