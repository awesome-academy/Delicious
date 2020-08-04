//
//  ShoppingListUseCase.swift
//  Delicious
//
//  Created by HoaPQ on 7/27/20.
//  Copyright © 2020 sun. All rights reserved.
//

protocol ShoppingListUseCaseType {
    func getShopingListRecipes() -> Observable<[ShoppingList]>
    func remove(list: ShoppingList) -> Observable<Void>
    func update(list: ShoppingList) -> Observable<Void>
}

struct ShoppingListUseCase: ShoppingListUseCaseType {
    private let repository = ShoppingListRepository()
    
    func getShopingListRecipes() -> Observable<[ShoppingList]> {
        return repository.getShopingLists()
    }
    
    func remove(list: ShoppingList) -> Observable<Void> {
        return repository.deleteItem(havingID: list.id)
    }
    
    func update(list: ShoppingList) -> Observable<Void> {
        return repository.update(list)
    }
}
