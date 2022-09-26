//   
//  ViperPresenter.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import Foundation

protocol ExplorePresenterType {
    
}

class ExplorePresenter: ExplorePresenterType {
    
    private let interactor: ExploreInteractorType
    private let router: ExploreRouterType
    private weak var view: ExploreViewType?
    
    init(interactor: ExploreInteractorType,
         router: ExploreRouterType,
         view: ExploreViewType) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}
