//   
//  FavoritesInteractor.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import Realm
import RealmSwift

protocol FavoritesInteractorType {
    var articles: [ArticleRealm] { get }
    
    func removeArticle(index: Int)
    func subscribeLocationNotification(completion: @escaping(RealmCollectionChange<Results<ArticleRealm>>) -> Void)
}

final class FavoritesInteractor: FavoritesInteractorType {
    
    private let realmManager = RealmManager.shared
    private var notificationToken: NotificationToken?
    
    var articles: [ArticleRealm] {
        realmManager.getObjects()
    }
    
    init() {}
    
    func removeArticle(index: Int) {
        let article = articles[index]
        realmManager.write { realm in
            article.isFavorite = false
            realm.delete(article)
        }
    }
    
    func subscribeLocationNotification(completion: @escaping(RealmCollectionChange<Results<ArticleRealm>>) -> Void) {
        notificationToken = realmManager.observeUpdateChanges(type: ArticleRealm.self, completion)
    }
}
