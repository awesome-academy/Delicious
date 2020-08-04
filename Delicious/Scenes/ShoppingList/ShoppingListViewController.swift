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

    @IBOutlet weak var tableView: RefreshTableView!
    
    // MARK: - Properties
    
    var viewModel: ShoppingListViewModel!
    var dataSource: RxTableViewSectionedReloadDataSource<ShoppingListSectionModel>!

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
        tableView.do {
            $0.register(cellType: ShoppingListTBCell.self)
            $0.backgroundView = EmptyView()
            $0.refreshFooter = nil
            $0.rx
                .setDelegate(self)
                .disposed(by: rx.disposeBag)
        }
    }

    func bindViewModel() {
        dataSource = RxTableViewSectionedReloadDataSource<ShoppingListSectionModel>(
            configureCell: { _, tableView, indexPath, ingredient in
                return tableView.dequeueReusableCell(for: indexPath,
                                                     cellType: ShoppingListTBCell.self).then {
                    $0.setUp(short: ingredient)
                }
            }
        )
        let input = ShoppingListViewModel.Input()
        let output = viewModel.transform(input)
    }
}

// MARK: - Binders
extension ShoppingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if dataSource.sectionModels.isEmpty { return nil }
        let shoppingList = dataSource.sectionModels[section].model
        return ShoppingListHeaderView.loadFromNib().then {
            $0.setUp(recipe: shoppingList)
        }
    }
}

// MARK: - StoryboardSceneBased
extension ShoppingListViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoards.shoppingList
}
