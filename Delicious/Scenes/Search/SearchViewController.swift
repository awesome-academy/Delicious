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
    private let searchBar: UISearchBar = UISearchBar().then {
        $0.searchTextField.textColor = .white
        $0.placeholder = "Search"
        $0.setImage(Icon.icSearch, for: .search, state: .normal)
    }
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var tableView: RefreshTableView!

    // MARK: - Properties

    var viewModel: SearchViewModel!
    private let collectionViewInset: CGFloat = 12

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
        navigationItem.titleView = searchBar
        collectionView.do {
            $0.register(cellType: TagCollectionViewCell.self)
            $0.register(supplementaryViewType: SearchCollectionViewHeader.self,
                        ofKind: UICollectionView.elementKindSectionHeader)
            $0.register(supplementaryViewType: SearchCollectionViewHeader.self,
                        ofKind: UICollectionView.elementKindSectionFooter)
            $0.contentInset = UIEdgeInsets(top: 0,
                                           left: collectionViewInset,
                                           bottom: 0,
                                           right: collectionViewInset)
            $0.rx
                .setDelegate(self)
                .disposed(by: rx.disposeBag)
        }
        tableView.do {
            $0.register(cellType: SuggestTableViewCell.self)
            $0.register(cellType: RecipeTBCell.self)
            $0.isHidden = true
        }
    }

    func bindViewModel() {
        let collectionViewDataSource = RxCollectionViewSectionedReloadDataSource<SearchCollectionViewSection>(
            configureCell: { (data, collectionView, indexPath, _) -> UICollectionViewCell in
                switch data[indexPath] {
                case .tag(let tag):
                    return collectionView.dequeueReusableCell(for: indexPath,
                                                              cellType: TagCollectionViewCell.self).then {
                        $0.setData(text: tag.textString)
                    }
                }
            },
            configureSupplementaryView: { (data, collectionView, kind, indexPath) -> UICollectionReusableView in
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           for: indexPath,
                                                                           viewType: SearchCollectionViewHeader.self)
                switch data[indexPath] {
                case .tag(let tag):
                    view.setTitle(tag.typeString)
                }
                return view
            }
        )

        let dataSource = RxTableViewSectionedReloadDataSource<SearchTableViewSection>(configureCell: { (data, tableView, indexPath, _) -> UITableViewCell in
            switch data[indexPath] {
            case .suggest(let text):
                return tableView.dequeueReusableCell(
                    for: indexPath,
                    cellType: SuggestTableViewCell.self
                ).then {
                    $0.setUp(text)
                }
            case .result(let recipe):
                return tableView.dequeueReusableCell(
                    for: indexPath,
                    cellType: RecipeTBCell.self
                ).then {
                    $0.setInfo(recipe: recipe)
                }
            }
        })

        let input = SearchViewModel.Input(loadTrigger: Driver.just(()))
        let output = viewModel.transform(input)

        output.tags
            .drive(collectionView.rx.items(dataSource: collectionViewDataSource))
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - Binders
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: Constant.tableHeaderSectionHeight)
    }
}

// MARK: - StoryboardSceneBased
extension SearchViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoards.search
}
