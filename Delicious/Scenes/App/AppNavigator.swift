//
//  AppNavigator.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 sun. All rights reserved.
//

protocol AppNavigatorType {
    func toMain()
}

struct AppNavigator: AppNavigatorType {
    unowned let window: UIWindow
    
    func toMain() {
        // MARK: Home
        let homeVC = HomeViewController.instantiate()
        let navHome = AppNavigationController(rootViewController: homeVC).then {
            $0.tabBarItem = UITabBarItem(title: Constant.homeTitle,
                                         image: Icon.icHomeNormal,
                                         selectedImage: Icon.icHomeSelected)
        }
        let homeNavigator = HomeNavigator(navigationController: navHome)
        let homeUseCase = HomeUseCase(repository: HomeRepository())
        let homeViewModel = HomeViewModel(navigator: homeNavigator,
                                          useCase: homeUseCase)
        homeVC.bindViewModel(to: homeViewModel)

        // MARK: Favorite
        let favoriteVC = FavoriteViewController.instantiate()
        let navFavorite = AppNavigationController(rootViewController: favoriteVC).then {
            $0.tabBarItem = UITabBarItem(title: Constant.favoriteTitle,
                                         image: Icon.icFavoriteSelected,
                                         selectedImage: Icon.icFavoriteSelectedOrange)
        }
        let favoriteNavigator = FavoriteNavigator(navigationController: navFavorite)
        let favoriteUseCase = FavoriteUseCase()
        let favoriteViewModel = FavoriteViewModel(navigator: favoriteNavigator,
                                                  useCase: favoriteUseCase)
        favoriteVC.bindViewModel(to: favoriteViewModel)

        // MARK: Shopping List
        let shoppingListVC = ShoppingListViewController.instantiate()
        let navShoppingList = AppNavigationController(rootViewController: shoppingListVC).then {
            $0.tabBarItem = UITabBarItem(title: Constant.shoppingListTitle,
                                         image: Icon.icShoping,
                                         selectedImage: Icon.icShopingSelected)
        }
        let shoppingListNavigator = ShoppingListNavigator(navigationController: navShoppingList)
        let shoppingListUseCase = ShoppingListUseCase()
        let shoppingListViewModel = ShoppingListViewModel(navigator: shoppingListNavigator,
                                                          useCase: shoppingListUseCase)
        shoppingListVC.bindViewModel(to: shoppingListViewModel)
        
        let tabBarController = UITabBarController().then {
            $0.tabBar.isTranslucent = false
            $0.tabBar.tintColor = .systemOrange
            $0.viewControllers = [navHome, navFavorite, navShoppingList]
        }
        window.rootViewController = tabBarController
    }
}
