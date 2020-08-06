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
    private lazy var searchBar: UISearchBar = UISearchBar().then {
        $0.searchTextField.textColor = .white
        $0.placeholder = "Search"
        $0.setImage(Icon.icSearch, for: .search, state: .normal)
        $0.delegate = self
    }
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var resultsTableView: RefreshTableView!
    @IBOutlet private weak var suggestTableView: UITableView!
    
    // MARK: - Properties

    var viewModel: SearchViewModel!
    private let collectionViewInset: CGFloat = 12
    private let loadTrigger = PublishSubject<Void>()
    private let searchTrigger = PublishSubject<String>()
    private let selectTrigger = PublishSubject<RecipeType>()

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
        resultsTableView.do {
            $0.register(cellType: RecipeTBCell.self)
            $0.backgroundView = EmptyView()
            $0.isHidden = true
        }
        suggestTableView.do {
            $0.register(cellType: SuggestTableViewCell.self)
            $0.isHidden = true
        }
        
    }

    func bindViewModel() {
        let collectionViewDataSource = RxCollectionViewSectionedReloadDataSource<SearchCollectionViewSection>(
            configureCell: { (_, collectionView, indexPath, item) -> UICollectionViewCell in
                return collectionView.dequeueReusableCell(
                    for: indexPath,
                    cellType: TagCollectionViewCell.self
                ).then {
                    $0.setData(text: item.textString)
                }
            },
            configureSupplementaryView: { (data, collectionView, kind, indexPath) -> UICollectionReusableView in
                return collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    for: indexPath,
                    viewType: SearchCollectionViewHeader.self
                ).then {
                    $0.setTitle(data[indexPath].typeString)
                }
            }
        )

        let resultsDataSource = RxTableViewSectionedReloadDataSource<SearchResultSection>(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
            return tableView.dequeueReusableCell(
                for: indexPath,
                cellType: RecipeTBCell.self
            ).then {
                $0.setInfo(recipe: item)
            }
        })
        
        let suggestDataSource = RxTableViewSectionedReloadDataSource<AutoCompletionSection>(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
            return tableView.dequeueReusableCell(
                for: indexPath,
                cellType: SuggestTableViewCell.self)
            .then {
                $0.setUp(item)
            }
        })
        
        let autoCompletion = searchBar.rx.text
            .orEmpty
            .asDriverOnErrorJustComplete()
            .do(onNext: { [weak self] text in
                if text.isEmpty {
                    self?.showTags()
                    self?.loadTrigger.onNext(())
                } else {
                    self?.showAutoCompletion()
                }
            })
            .debounce(Constant.throttle)
            .distinctUntilChanged()

        let input = SearchViewModel.Input(
            loadTrigger: loadTrigger.startWith(()).asDriverOnErrorJustComplete(),
            searchTrigger: searchTrigger.asDriverOnErrorJustComplete(),
            tagTrigger: collectionView.rx
                                      .modelSelected(SearchTag.self)
                                      .asDriver(),
            reloadTrigger: resultsTableView.loadMoreTopTrigger,
            loadMoreTrigger: resultsTableView.loadMoreBottomTrigger,
            autoCompletion: autoCompletion,
            selectTrigger: selectTrigger.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input)
        
        suggestTableView.rx
            .modelSelected(String.self)
            .do(onNext: {
                self.searchBar.text = $0
                self.searchTrigger.onNext($0)
                self.showResults()
            })
            .asDriverOnErrorJustComplete()
            .drive()
            .disposed(by: rx.disposeBag)
        output.tags
            .drive(collectionView.rx.items(dataSource: collectionViewDataSource))
            .disposed(by: rx.disposeBag)
        output.results
            .drive(resultsTableView.rx.items(dataSource: resultsDataSource))
            .disposed(by: rx.disposeBag)
        output.autoCompletions
            .drive(suggestTableView.rx.items(dataSource: suggestDataSource))
            .disposed(by: rx.disposeBag)
        output.state
            .drive(resultsTableView.rx.state)
            .disposed(by: rx.disposeBag)
        output.isLoading
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
        output.isReloading
            .drive(resultsTableView.isLoadingMoreTop)
            .disposed(by: rx.disposeBag)
        output.isLoadmore
            .drive(resultsTableView.isLoadingMoreBottom)
            .disposed(by: rx.disposeBag)
        output.selected
            .drive()
            .disposed(by: rx.disposeBag)
        output.searched
            .do(onNext: showResults)
            .drive()
            .disposed(by: rx.disposeBag)
    }
    
    private func showAutoCompletion() {
        collectionView.isHidden = true
        resultsTableView.isHidden = true
        suggestTableView.isHidden = false
    }
    
    private func showResults() {
        collectionView.isHidden = true
        resultsTableView.isHidden = false
        suggestTableView.isHidden = true
    }
    
    private func showTags() {
        collectionView.isHidden = false
        resultsTableView.isHidden = true
        suggestTableView.isHidden = true
    }
}

// MARK: - Binders
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: Constant.tableHeaderSectionHeight)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        searchTrigger.onNext(query)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadTrigger.onNext(())
    }
}

// MARK: - StoryboardSceneBased
extension SearchViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoards.search
}
