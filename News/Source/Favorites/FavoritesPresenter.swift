//   
//  FavoritesPresenter.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import Foundation

protocol FavoritesPresenterType {
    
}

final class FavoritesPresenter: FavoritesPresenterType {
    
    private let interactor: FavoritesInteractorType
    private let router: FavoritesRouterType
    private weak var view: FavoritesViewType?
    
    init(interactor: FavoritesInteractorType,
         router: FavoritesRouterType,
         view: FavoritesViewType) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}
