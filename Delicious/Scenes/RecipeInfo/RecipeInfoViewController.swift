//
//  RecipeInfoViewController.swift
//  Delicious
//
//  Created by HoaPQ on 7/31/20.
//  Copyright © 2020 sun. All rights reserved.
//

import UIKit
import Reusable

final class RecipeInfoViewController: UIViewController, BindableType {
    
    // MARK: - IBOutlets
    
    // MARK: - Properties
    
    var viewModel: RecipeInfoViewModel!

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
        navigationItem.title = "Recipe Information"
    }

    func bindViewModel() {
        let input = RecipeInfoViewModel.Input()
        let output = viewModel.transform(input)
    }
}

// MARK: - Binders
extension RecipeInfoViewController {

}

// MARK: - StoryboardSceneBased
extension RecipeInfoViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoards.recipeInfo
}
