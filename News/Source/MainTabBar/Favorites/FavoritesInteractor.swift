//   
//  FavoritesInteractor.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import Realm
import RealmSwift

protocol FavoritesInteractorType {
    var articles: [Article] { get }
    
    func removeArticle(index: Int)
    func subscribeLocationNotification(completion: @escaping(RealmCollectionChange<Results<Article>>) -> Void)
}

final class FavoritesInteractor: FavoritesInteractorType {
    
    private let realmManager = RealmManager.shared
    private var notificationToken: NotificationToken?
    
    var articles: [Article] {
        realmManager.getObjects()
    }
    
    init() {}
    
    func removeArticle(index: Int) {
        let article = articles[index]
        realmManager.write { realm in
            guard let article = realm.objects(Article.self).first(where: { $0.url == article.url }) else { return }
            
            article.isFavorite = false
            realm.delete(article)
        }
    }
    
    func subscribeLocationNotification(completion: @escaping(RealmCollectionChange<Results<Article>>) -> Void) {
        notificationToken = realmManager.observeUpdateChanges(type: Article.self, completion)
    }
}
