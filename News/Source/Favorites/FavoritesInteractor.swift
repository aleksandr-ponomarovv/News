//   
//  FavoritesInteractor.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import Foundation

protocol FavoritesInteractorType {
    var articles: [Article] { get }
    
    func removeArticle(index: Int)
}

final class FavoritesInteractor: FavoritesInteractorType {
    
    private let realmManager = RealmManager.shared
    
    var articles: [Article] {
        realmManager.getObjects()
    }
    
    init() {}
    
    func removeArticle(index: Int) {
        let article = articles[index]
        realmManager.deleteObject(object: article)
    }
}
