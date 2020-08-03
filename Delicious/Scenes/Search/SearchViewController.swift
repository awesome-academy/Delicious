//
//  SearchViewController.swift
//  Delicious
//
//  Created by HoaPQ on 7/31/20.
//  Copyright © 2020 sun. All rights reserved.
//

import UIKit
import Reusable

final class SearchViewController: UIViewController, BindableType {
    
    // MARK: - IBOutlets
    
    // MARK: - Properties
    
    var viewModel: SearchViewModel!

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
        navigationItem.title = "Search"
    }

    func bindViewModel() {
        let input = SearchViewModel.Input()
        let output = viewModel.transform(input)
    }
}

// MARK: - Binders
extension SearchViewController {

}

// MARK: - StoryboardSceneBased
extension SearchViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoards.search
}
