//   
//  AppCoordinator.swift
//  News
//
//  Created by Aleksandr on 25.09.2022.
//

import UIKit

protocol BaseCoordinator {
    func start()
}

class AppCoordinator: BaseCoordinator {
    
    private lazy var window: UIWindow? = {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .light
        return window
    }()
    
    func start() {
        window?.rootViewController = startController()
        window?.makeKeyAndVisible()
    }
}

// MARK: - Private methods
private extension AppCoordinator {
    func startController() -> UIViewController {
        let tabBar = MainTabBarController()
        tabBar.viewControllers = [exploreScreen(), favoritesScreen()]
        return tabBar
    }
    
    func exploreScreen() -> UIViewController {
        let viewController = ExploreViewController()
        let configurator: ExploreConfiguratorType = ExploreConfigurator()
        configurator.configure(viewController: viewController)
        viewController.tabBarItem = UITabBarItem(title: "Explore", image: nil, tag: 0)
        return viewController
    }
    
    func favoritesScreen() -> UIViewController {
        let viewController = FavoritesViewController()
        let configurator: FavoritesConfiguratorType = FavoritesConfigurator()
        configurator.configure(viewController: viewController)
        viewController.tabBarItem = UITabBarItem(title: "Favorites", image: nil, tag: 1)
        return viewController
    }
}
