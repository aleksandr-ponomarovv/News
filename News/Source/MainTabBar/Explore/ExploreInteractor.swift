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
    func updateArticles()
    func subscribeLocationNotification(completion: @escaping(RealmCollectionChange<Results<ArticleRealm>>) -> Void)
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
                articleEntity.articles = self.updateFavoriteStates(articles: articleEntity.articles)
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
                let articleRealm = self.getArticleRealm(article: article)
                articleRealm.isFavorite = isFavorite
                realm.add(articleRealm, update: .all)
            } else {
                guard let article = realm.objects(ArticleRealm.self).first(where: { $0.url == article.url }) else { return }

                realm.delete(article)
            }
        }
        articleEntity?.articles[index].isFavorite = isFavorite
    }
    
    func updateArticles() {
        guard let articles = articleEntity?.articles else { return }
        
        articleEntity?.articles = updateFavoriteStates(articles: articles)
    }
    
    func subscribeLocationNotification(completion: @escaping(RealmCollectionChange<Results<ArticleRealm>>) -> Void) {
        notificationToken = realmManager.observeUpdateChanges(type: ArticleRealm.self, completion)
    }
}

// MARK: - Private methods
private extension ExploreInteractor {
    func updateFavoriteStates(articles: [Article]) -> [Article] {
        var updatedArticles = articles
        let savedArticles: [ArticleRealm] = self.realmManager.getObjects()
        
        for (index, article) in articles.enumerated() {
            updatedArticles[index].isFavorite = savedArticles.contains(where: { $0.url == article.url })
        }
        return updatedArticles
    }
    
    func getArticleRealm(article: Article) -> ArticleRealm {
        let articleRealm = ArticleRealm()
        articleRealm.url = article.url
        articleRealm.source = article.source
        articleRealm.author = article.author
        articleRealm.title = article.title
        articleRealm.articleDescription = article.articleDescription
        articleRealm.urlToImage = article.urlToImage
        articleRealm.publishedAt = article.publishedAt
        articleRealm.content = article.content
        return articleRealm
    }
}
