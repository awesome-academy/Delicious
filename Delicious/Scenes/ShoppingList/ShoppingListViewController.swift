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
    private var dataSource: RxTableViewSectionedReloadDataSource<ShoppingListSectionModel>!
    
    private let loadTrigger = PublishSubject<Void>()
    private let selectTitleTrigger = PublishSubject<RecipeType>()
    private let deleteTrigger = PublishSubject<ShoppingList>()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTrigger.onNext(())
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
            $0.sectionHeaderHeight = UITableView.automaticDimension
            $0.estimatedSectionHeaderHeight = 38
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
        let input = ShoppingListViewModel.Input(
            loadTrigger: loadTrigger.asDriverOnErrorJustComplete(),
            reloadTrigger: tableView.loadMoreTopTrigger,
            selectTrigger: tableView.rx.itemSelected
                                    .asDriver()
                                    .throttle(Constant.throttle),
            selectTitleTrigger: selectTitleTrigger
                                    .asDriverOnErrorJustComplete()
                                    .throttle(Constant.throttle),
            deleteTrigger: deleteTrigger
                                    .asDriverOnErrorJustComplete()
                                    .throttle(Constant.throttle)
        )
        let output = viewModel.transform(input)
        output.data
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        output.state
            .do(onNext: { [weak self] state in
                switch state {
                case .normal:
                    self?.tableView.separatorStyle = .singleLine
                default:
                    self?.tableView.separatorStyle = .none
                }
            })
            .drive(tableView.rx.state)
            .disposed(by: rx.disposeBag)
        output.isLoading
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
        output.isReloading
            .drive(tableView.isLoadingMoreTop)
            .disposed(by: rx.disposeBag)
        output.error
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        output.selected
            .drive(loadTrigger)
            .disposed(by: rx.disposeBag)
        output.selectedTitle
            .drive()
            .disposed(by: rx.disposeBag)
        output.deleted
            .drive(loadTrigger)
            .disposed(by: rx.disposeBag)
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
            $0.tapTitle = { [weak self] recipe in
                self?.selectTitleTrigger.onNext(recipe)
            }
            $0.tapRemove = { [weak self] recipe in
                self?.deleteTrigger.onNext(recipe)
            }
        }
    }
}

// MARK: - StoryboardSceneBased
extension ShoppingListViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoards.shoppingList
}
