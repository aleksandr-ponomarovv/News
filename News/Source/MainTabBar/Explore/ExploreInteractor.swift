//   
//  ViperInteractor.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import Realm
import RealmSwift

protocol ExploreInteractorType {
    var articleEntity: ArticleEntity? { get }
    var isLoading: Bool { get }
    var isLastPage: Bool { get }
    
    func fetchNextPage(completion: @escaping (Response<Bool>) -> Void)
    func fetchNews(serchText: String, page: Int, completion: @escaping (Response<Bool>) -> Void)
    func setupArticleToDatabase(at index: Int, isFavorite: Bool)
    func subscribeLocationNotification(completion: @escaping(RealmCollectionChange<Results<Article>>) -> Void)
}

final class ExploreInteractor: ExploreInteractorType {
    
    var articleEntity: ArticleEntity?
    var isLoading: Bool = false
    
    private let realmManager = RealmManager.shared
    private let newsService = NewsService()
    private var page: Int = 1
    private var serchText: String = ""
    private var notificationToken: NotificationToken?
    
    var isLastPage: Bool {
        guard let articleEntity = articleEntity else { return false }
        
        let total = articleEntity.totalResults
        let countArticles = articleEntity.articles.count
        return total == countArticles
    }
    
    func fetchNextPage(completion: @escaping (Response<Bool>) -> Void) {
        fetchNews(serchText: serchText, page: page + 1, completion: completion)
    }
    
    func fetchNews(serchText: String, page: Int, completion: @escaping (Response<Bool>) -> Void) {
        isLoading = true
        newsService.getEverything(serchText: serchText, page: page) { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            switch result {
            case .success(let articleEntity):
                self.updateFavoriteStates(articles: articleEntity.articles)
                switch page {
                case 1:
                    self.articleEntity = articleEntity
                    self.serchText = serchText
                default:
                    self.articleEntity?.articles.append(contentsOf: articleEntity.articles)
                }
                self.page = page
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func setupArticleToDatabase(at index: Int, isFavorite: Bool) {
        guard let article = articleEntity?.articles[index] else { return }
        
        realmManager.write { realm in
            if isFavorite {
                realm.add(article, update: .all)
                article.isFavorite = true
            } else {
                guard let article = realm.objects(Article.self).first(where: { $0.url == article.url }) else { return }
                
                article.isFavorite = false
                realm.delete(article)
            }
        }
    }
    
    func subscribeLocationNotification(completion: @escaping(RealmCollectionChange<Results<Article>>) -> Void) {
        notificationToken = realmManager.observeUpdateChanges(type: Article.self, completion)
    }
}

// MARK: - Private methods
private extension ExploreInteractor {
    func updateFavoriteStates(articles: [Article]) {
        let savedArticles: [Article] = realmManager.getObjects()
        guard !savedArticles.isEmpty && !articles.isEmpty else { return }
        
        savedArticles.forEach { savedArticle in
            articles.first { $0.url == savedArticle.url }?.isFavorite = true
        }
    }
}
