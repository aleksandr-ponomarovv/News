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
    func refreshAction(serchText: String?)
    func articleCellModel(at indexPath: IndexPath) -> ArticleTableViewCellModel?
    func favoriteButtonCompletion(at indexPath: IndexPath) -> ((Bool) -> Void)
    func didSelectArticle(at indexPath: IndexPath)
    func fetchNews(serchText: String)
    func fetchNextPage()
}

final class ExplorePresenter: ExplorePresenterType {
    
    private let interactor: ExploreInteractorType
    private let router: ExploreRouterType
    private weak var view: ExploreViewType?
    
    private var serchText: String = ""
    
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
    
    func refreshAction(serchText: String?) {
        if let serchText = serchText,
           !serchText.isEmpty {
            fetchNews(serchText: serchText)
        } else {
            fetchNews()
        }
    }
    
    func articleCellModel(at indexPath: IndexPath) -> ArticleTableViewCellModel? {
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
    
    func fetchNews(serchText: String = "telegram") {
        interactor.fetchNews(serchText: serchText, page: 1, completion: fetchNewsCompletion)
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
        case .failure(let error):
            self.view?.hideTableIndicators()
        }
    }
    
    func subscribeLocationNotification() {
        interactor.subscribeLocationNotification { [weak self] change in
            guard let self = self else { return }
            
            switch change {
            case .initial, .update:
                self.view?.updateTableView()
            case .error:
                break
            }
        }
    }
}
