//   
//  FavoritesRouter.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import Foundation

protocol FavoritesRouterType {
    
}

class FavoritesRouter: FavoritesRouterType {
    
    private weak var viewController: FavoritesViewController?
    
    init(viewController: FavoritesViewController) {
        self.viewController = viewController
    }
}
