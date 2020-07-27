//
//  FavoriteViewController.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 sun. All rights reserved.
//

import UIKit
import Reusable

final class FavoriteViewController: UIViewController, BindableType {
    
    // MARK: - IBOutlets
    
    // MARK: - Properties
    
    var viewModel: FavoriteViewModel!

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
        navigationItem.title = Constant.favoriteTitle
    }

    func bindViewModel() {
        let input = FavoriteViewModel.Input()
        let output = viewModel.transform(input)
    }
}

// MARK: - Binders
extension FavoriteViewController {

}

// MARK: - StoryboardSceneBased
extension FavoriteViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoards.favorite
}
