//   
//  ViperRouter.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import Foundation

protocol ExploreRouterType {
    
}

class ExploreRouter: ExploreRouterType {
    
    private weak var viewController: ExploreViewController?
    
    init(viewController: ExploreViewController) {
        self.viewController = viewController
    }
}
