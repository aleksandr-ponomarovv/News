//   
//  ViperConfigurator.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import Foundation

protocol ExploreConfiguratorType {
    func configure(viewController: ExploreViewController)
}

class ExploreConfigurator: ExploreConfiguratorType {
    
    func configure(viewController: ExploreViewController) {
        let interactor = ExploreInteractor()
        let router = ExploreRouter(viewController: viewController)
        let presenter = ExplorePresenter(interactor: interactor, router: router, view: viewController)
        viewController.presenter = presenter
    }
}
