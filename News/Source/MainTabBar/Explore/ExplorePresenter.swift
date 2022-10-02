//   
//  ViperPresenter.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import Foundation

protocol ExplorePresenterType {
    var numberOfRowsInSection: Int { get }
    var hasMoreNews: Bool { get }
    
    func viewDidLoad()
    func refreshAction(searchText: String?)
    func articleCellModel(at indexPath: IndexPath) -> Article?
    func favoriteButtonCompletion(at indexPath: IndexPath) -> ((Bool) -> Void)
    func didSelectArticle(at indexPath: IndexPath)
    func fetchNews(searchText: String)
    func fetchNextPage()
}

final class ExplorePresenter: ExplorePresenterType {
    
    private let interactor: ExploreInteractorType
    private let router: ExploreRouterType
    private weak var view: ExploreViewType?
    
    private var searchText: String = ""
    
    var numberOfRowsInSection: Int {
        interactor.articleEntity?.articles.count ?? 0
    }
    
    var hasMoreNews: Bool {
        !interactor.isLoading && !interactor.isLastPage
    }
    
    init(interactor: ExploreInteractorType,
         router: ExploreRouterType,
         view: ExploreViewType) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        fetchNews()
        subscribeLocationNotification()
    }
    
    func refreshAction(searchText: String?) {
        if let searchText = searchText,
           !searchText.isEmpty {
            fetchNews(searchText: searchText)
        } else {
            fetchNews()
        }
    }
    
    func articleCellModel(at indexPath: IndexPath) -> Article? {
        return interactor.articleEntity?.articles[indexPath.row]
    }
    
    func favoriteButtonCompletion(at indexPath: IndexPath) -> ((Bool) -> Void) {
        return { [weak self] isFavorite in
            guard let self = self else { return }
            
            self.interactor.setupArticleToDatabase(at: indexPath.row, isFavorite: isFavorite)
        }
    }
    
    func didSelectArticle(at indexPath: IndexPath) {
        guard let url = interactor.articleEntity?.articles[indexPath.row].url else { return }
        router.showWebViewerScreen(url: url)
    }
    
    func fetchNews(searchText: String = "telegram") {
        guard !searchText.isEmpty else { return }
        
        interactor.fetchNews(searchText: searchText, page: 1, completion: fetchNewsCompletion)
    }
    
    func fetchNextPage() {
        interactor.fetchNextPage(completion: fetchNewsCompletion)
    }
}

// MARK: - Private methods
private extension ExplorePresenter {
    func fetchNewsCompletion(result: (Response<Bool>)) {
        switch result {
        case .success:
            self.view?.updateTableView()
        case .failure:
            self.view?.hideTableIndicators()
        }
    }
    
    func subscribeLocationNotification() {
        interactor.subscribeLocationNotification { [weak self] change in
            guard let self = self else { return }
            
            switch change {
            case .initial, .update:
                self.interactor.updateArticles()
                self.view?.updateTableView()
            case .error:
                break
            }
        }
    }
}
