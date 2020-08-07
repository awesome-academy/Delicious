//
//  SearchViewController.swift
//  Delicious
//
//  Created by HoaPQ on 7/31/20.
//  Copyright © 2020 sun. All rights reserved.
//

import MaterialComponents

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
    @IBOutlet private weak var tagCollectionView: UICollectionView!
    @IBOutlet private weak var resultsView: UIView!
    
    // MARK: - Properties

    var viewModel: SearchViewModel!
    private let collectionViewInset: CGFloat = 12
    private let loadTrigger = PublishSubject<Void>()
    private let searchTrigger = PublishSubject<String>()
    private let selectTrigger = PublishSubject<RecipeType>()
    private let removeTagTrigger = PublishSubject<SearchTag>()
    private let autoFooter = RefreshAutoFooter()
    
    private var showAutoCompletion: Binder<Void> {
        return Binder(self) { (viewController, _) in
            viewController._showAutoCompletion()
        }
    }
    private var showResults: Binder<Void> {
        return Binder(self) { (viewController, _) in
            viewController._showResults()
        }
    }
    private var showTags: Binder<Void> {
        return Binder(self) { (viewController, _) in
            viewController._showTags()
        }
    }
    private var hasMorePage: Binder<Bool> {
        return Binder(self) { viewController, status in
            viewController.resultsTableView.refreshFooter = status ? viewController.autoFooter : nil
        }
    }

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
            $0.register(cellType: StackTagCell.self)
            $0.backgroundView = EmptyView()
            $0.rx
                .setDelegate(self)
                .disposed(by: rx.disposeBag)
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

        let resultsDataSource = RxTableViewSectionedReloadDataSource<SearchResultSection>(
            configureCell: { [weak self] (_, tableView, indexPath, item) -> UITableViewCell in
                switch item {
                case .recipe(let recipe):
                    return tableView.dequeueReusableCell(
                        for: indexPath,
                        cellType: RecipeTBCell.self
                    ).then {
                        $0.setInfo(recipe: recipe)
                    }
                case .tags(let tags):
                    return tableView.dequeueReusableCell(
                        for: indexPath,
                        cellType: StackTagCell.self
                    ).then {
                        $0.setUp(tags: tags)
                        $0.tapDelete = {
                            self?.removeTagTrigger.onNext($0)
                        }
                    }
                }
            }
        )

        let suggestDataSource = RxTableViewSectionedReloadDataSource<AutoCompletionSection>(configureCell: { (_, tableView, indexPath, item) -> UITableViewCell in
            return tableView.dequeueReusableCell(
                for: indexPath,
                cellType: SuggestTableViewCell.self
            ).then {
                $0.setUp(item)
            }
        })

        let autoCompletion = searchBar.rx.text
            .orEmpty
            .asDriverOnErrorJustComplete()
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
            selectTrigger: resultsTableView.rx
                                           .modelSelected(SearchResultItem.self)
                                           .asDriver(),
            removeTagTrigger: removeTagTrigger.asDriverOnErrorJustComplete()
        )
        let output = viewModel.transform(input)

        suggestTableView.rx
            .modelSelected(String.self)
            .do(onNext: { [weak self] in
                self?.searchBar.text = $0
                self?.searchTrigger.onNext($0)
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
        output.hasMorePage
            .drive(hasMorePage)
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
        output.showResults
            .drive(showResults)
            .disposed(by: rx.disposeBag)
        output.showTags
            .drive(showTags)
            .disposed(by: rx.disposeBag)
        output.showAutoCompletion
            .drive(showAutoCompletion)
            .disposed(by: rx.disposeBag)
    }

    private func _showAutoCompletion() {
        collectionView.isHidden = true
        resultsView.isHidden = true
        suggestTableView.isHidden = false
    }

    private func _showResults() {
        collectionView.isHidden = true
        resultsView.isHidden = false
        suggestTableView.isHidden = true
    }

    private func _showTags() {
        loadTrigger.onNext(())
        collectionView.isHidden = false
        resultsView.isHidden = true
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

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - StoryboardSceneBased
extension SearchViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoards.search
}
