//
//  FavoriteViewController.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 sun. All rights reserved.
//

final class FavoriteViewController: UIViewController, BindableType {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: RefreshTableView!
    
    // MARK: - Properties
    
    var viewModel: FavoriteViewModel!
    private let loadTrigger = PublishSubject<Void>()

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
        navigationItem.title = Constant.favoriteTitle
        tableView.do {
            $0.register(cellType: RecipeTBCell.self)
            $0.backgroundView = EmptyView()
            $0.refreshFooter = nil
            $0.rx
                .setDelegate(self)
                .disposed(by: rx.disposeBag)
        }
    }

    func bindViewModel() {
        let dataSource = RxTableViewSectionedAnimatedDataSource<RecipeListSectionModel>(
            animationConfiguration: AnimationConfiguration(insertAnimation: .right,
                                                           reloadAnimation: .none,
                                                           deleteAnimation: .left),
            configureCell: { _, tableView, indexPath, recipe in
                return tableView.dequeueReusableCell(for: indexPath,
                                                     cellType: RecipeTBCell.self).then {
                    $0.setInfo(recipe: recipe)
                }
            },
            canEditRowAtIndexPath: { _, _ in
                return true
            }
        )
        
        let input = FavoriteViewModel.Input(
            loadTrigger: loadTrigger.asDriverOnErrorJustComplete(),
            reloadTrigger: tableView.loadMoreTopTrigger,
            selectTrigger: tableView.rx.modelSelected(FavoriteRecipe.self)
                                    .asDriver()
                                    .throttle(Constant.throttle),
            deleteTrigger: tableView.rx.modelDeleted(FavoriteRecipe.self)
                                    .asDriver()
                                    .throttle(Constant.throttle)
        )
        let output = viewModel.transform(input)
        
        output.data
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)
        output.isLoading
            .drive(rx.isLoading)
            .disposed(by: rx.disposeBag)
        output.isReloading
            .drive(tableView.isLoadingMoreTop)
            .disposed(by: rx.disposeBag)
        output.state
            .drive(tableView.rx.state)
            .disposed(by: rx.disposeBag)
        output.error
            .drive(rx.error)
            .disposed(by: rx.disposeBag)
        output.selected
            .drive()
            .disposed(by: rx.disposeBag)
        output.deleted
            .drive(loadTrigger)
            .disposed(by: rx.disposeBag)
    }
}

// MARK: - Binders
extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - StoryboardSceneBased
extension FavoriteViewController: StoryboardSceneBased {
    static var sceneStoryboard = StoryBoards.favorite
}
