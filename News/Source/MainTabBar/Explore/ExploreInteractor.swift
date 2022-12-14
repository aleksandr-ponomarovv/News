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
    func fetchNews(searchText: String, page: Int, completion: @escaping (Response<Bool>) -> Void)
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
    private var searchText: String = ""
    private var notificationToken: NotificationToken?
    
    var isLastPage: Bool {
        guard let articleEntity = articleEntity else { return false }
        
        let total = articleEntity.totalResults
        let countArticles = articleEntity.articles.count
        return total == countArticles
    }
    
    func fetchNextPage(completion: @escaping (Response<Bool>) -> Void) {
        fetchNews(searchText: searchText, page: page + 1, completion: completion)
    }
    
    func fetchNews(searchText: String, page: Int, completion: @escaping (Response<Bool>) -> Void) {
        isLoading = true
        newsService.getEverything(searchText: searchText, page: page) { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            switch result {
            case .success(let articleEntity):
                self.updateFavoriteStates(articles: articleEntity.articles)
                switch page {
                case 1:
                    self.articleEntity = articleEntity
                    self.searchText = searchText
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
        
        updateFavoriteStates(articles: articles)
    }
    
    func subscribeLocationNotification(completion: @escaping(RealmCollectionChange<Results<ArticleRealm>>) -> Void) {
        notificationToken = realmManager.observeUpdateChanges(type: ArticleRealm.self, completion)
    }
}

// MARK: - Private methods
private extension ExploreInteractor {
    func updateFavoriteStates(articles: [Article]) {
        let savedArticles: [ArticleRealm] = realmManager.getObjects()
        guard !savedArticles.isEmpty else { return }
        
        articles.forEach { article in
            article.isFavorite = savedArticles.contains { $0.url == article.url }
        }
    }
    
    func getArticleRealm(article: Article) -> ArticleRealm {
        let articleRealm = ArticleRealm()
        articleRealm.url = article.url
        articleRealm.source = article.source
        articleRealm.author = article.author
        articleRealm.title = article.title
        articleRealm.articleDescription = article.articleDescription
        articleRealm.imageUrl = article.imageUrl
        articleRealm.publishedAt = article.publishedAt
        articleRealm.content = article.content
        return articleRealm
    }
}
