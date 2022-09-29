//   
//  FavoritesPresenter.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import Foundation

protocol FavoritesPresenterType {
    var numberOfRowsInSection: Int { get }
    
    func articleCellModel(at indexPath: IndexPath) -> ArticleTableViewCellModel?
    func favoriteButtonCompletion(at indexPath: IndexPath) -> (() -> Void)
}

final class FavoritesPresenter: FavoritesPresenterType {
    
    private let interactor: FavoritesInteractorType
    private let router: FavoritesRouterType
    private weak var view: FavoritesViewType?
    
    var numberOfRowsInSection: Int {
        interactor.articles.count
    }
    
    init(interactor: FavoritesInteractorType,
         router: FavoritesRouterType,
         view: FavoritesViewType) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func articleCellModel(at indexPath: IndexPath) -> ArticleTableViewCellModel? {
        return interactor.articles[indexPath.row]
    }
    
    func favoriteButtonCompletion(at indexPath: IndexPath) -> (() -> Void) {
        return { [weak self] in
            guard let self = self else { return }
            
            self.interactor.removeArticle(index: indexPath.row)
            self.view?.reloadTableView()
        }
    }
}
