//
//  ShoppingListViewController.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 sun. All rights reserved.
//

import UIKit
import Reusable

final class ShoppingListViewController: UIViewController, BindableType {
    
    // MARK: - IBOutlets
    
    // MARK: - Properties
    
    var viewModel: ShoppingListViewModel!

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
        navigationItem.title = Constant.shoppingListTitle
    }

    func bindViewModel() {
        let input = ShoppingListViewModel.Input()
        let output = viewModel.transform(input)
    }
}

// MARK: - Binders
extension ShoppingListViewController {

}

// MARK: - StoryboardSceneBased
extension ShoppingListViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoards.shoppingList
}
