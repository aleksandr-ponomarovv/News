//   
//  FavoritesPresenter.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import Foundation

protocol FavoritesPresenterType {
    var numberOfRowsInSection: Int { get }
    
    func viewDidLoad()
    func articleCellModel(at indexPath: IndexPath) -> ArticleTableViewCellModel?
    func favoriteButtonCompletion(at indexPath: IndexPath) -> ((Bool) -> Void)
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
    
    func viewDidLoad() {
        subscribeLocationNotification()
    }
    
    func articleCellModel(at indexPath: IndexPath) -> ArticleTableViewCellModel? {
        return interactor.articles[indexPath.row]
    }
    
    func favoriteButtonCompletion(at indexPath: IndexPath) -> ((Bool) -> Void) {
        return { [weak self] _ in
            guard let self = self else { return }
            
            self.interactor.removeArticle(index: indexPath.row)
        }
    }
}

// MARK: - Private methods
private extension FavoritesPresenter {
    func subscribeLocationNotification() {
        interactor.subscribeLocationNotification { [weak self] change in
            guard let self = self else { return }
            
            switch change {
            case .initial, .update:
                self.view?.reloadTableView()
            case .error:
                break
            }
        }
    }
}
