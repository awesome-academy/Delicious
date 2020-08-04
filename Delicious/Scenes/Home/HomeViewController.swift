//
//  HomeViewController.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 sun. All rights reserved.
//

import UIKit
import Reusable
import RxDataSources

final class HomeViewController: UIViewController, BindableType {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: RefreshTableView!
    @IBOutlet private weak var searchButton: UIBarButtonItem!
    
    // MARK: - Properties
    private let featureTitle = "FEATURED"
    private let latestTitle = "LATEST"
    private let featuredCellHeight: CGFloat = 160
    private var dataSource: RxTableViewSectionedReloadDataSource<HomeTableViewSection>!
    private var featuredRecipes = [Int: [RecipeType]]()
    
    private let selectTrigger = PublishSubject<RecipeType>()
    private let loadTrigger = PublishSubject<Void>()
    
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
        tableView.do {
            $0.register(cellType: FeaturedTBCell.self)
            $0.register(cellType: RecipeTBCell.self)
            $0.estimatedRowHeight = UITableView.automaticDimension
            $0.sectionHeaderHeight = UITableView.automaticDimension
            $0.estimatedSectionHeaderHeight = Constant.tableHeaderSectionHeight
            $0.backgroundView = EmptyView()
            $0.refreshFooter = nil
            $0.rx.setDelegate(self).disposed(by: rx.disposeBag)
        }
        
        dataSource = RxTableViewSectionedReloadDataSource<HomeTableViewSection>(configureCell: { [weak self] (dataSource, tableView, indexPath, _) -> UITableViewCell in
            switch dataSource[indexPath] {
            case .featuredItem(let recipes):
                let cell = tableView.dequeueReusableCell(
                                for: indexPath,
                                cellType: FeaturedTBCell.self).then {
                                    guard let `self` = self else { return }
                                    self.featuredRecipes[indexPath.section] = recipes
                                    $0.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
                }
                return cell
            case .latestItem(let recipe):
                let cell = tableView.dequeueReusableCell(
                                for: indexPath,
                                cellType: RecipeTBCell.self)
                            cell.setInfo(recipe: recipe)
                return cell
            }
        })
    }

    func bindViewModel() {
        let input = HomeViewModel.Input(
            loadTrigger: loadTrigger.startWith(()).asDriverOnErrorJustComplete(),
            reloadTrigger: tableView.loadMoreTopTrigger,
            selectTrigger: selectTrigger.asDriverOnErrorJustComplete().throttle(Constant.throttle),
            selectItemTrigger: tableView.rx.modelSelected(HomeTableViewItem.self).asDriver().throttle(Constant.throttle),
            searchTrigger: searchButton.rx.tap.asDriver().throttle(Constant.throttle)
        )
        
        let output = viewModel.transform(input)
        
        output.isLoading
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
        output.isReloading
            .drive(tableView.isLoadingMoreTop)
            .disposed(by: rx.disposeBag)
        output.tableViewState
            .drive(tableView.rx.state)
            .disposed(by: rx.disposeBag)
        output.loadedError
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        output.selected
            .drive()
            .disposed(by: rx.disposeBag)
        output.search
            .drive()
            .disposed(by: rx.disposeBag)
        output.data
            .do(onNext: { _ in self.featuredRecipes.removeAll() })
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        tableView.rx.action
            .bind(to: loadTrigger)
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - Binders
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HomeTableHeaderView.loadFromNib().then {
            var title = ""
            if dataSource.sectionModels.isEmpty {
                return
            }
            switch dataSource.sectionModels[section] {
            case .featuredSection:
                title = featureTitle
            case .latestSection:
                title = latestTitle
            }
            $0.setUp(title: title)
        }
        return header
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = collectionView.tag
        return featuredRecipes[section]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: FeaturedCLCell.self)
        let section = collectionView.tag
        guard let recipe = featuredRecipes[section]?[indexPath.row] else { return cell }
        cell.setInfo(with: recipe)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let recipe = featuredRecipes[indexPath.section]?[indexPath.row] else { return }
        selectTrigger.onNext(recipe)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = featuredCellHeight
        let width = height / 393 * 636
        return CGSize(width: width, height: height)
    }
}

// MARK: - StoryboardSceneBased
extension HomeViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoards.home
}
