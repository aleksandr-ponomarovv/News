//   
//  FavoritesConfigurator.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import Foundation

protocol FavoritesConfiguratorType {
    func configure(viewController: FavoritesViewController)
}

class FavoritesConfigurator: FavoritesConfiguratorType {
    
    func configure(viewController: FavoritesViewController) {
        let interactor = FavoritesInteractor()
        let router = FavoritesRouter(viewController: viewController)
        let presenter = FavoritesPresenter(interactor: interactor, router: router, view: viewController)
        viewController.presenter = presenter
    }
}
