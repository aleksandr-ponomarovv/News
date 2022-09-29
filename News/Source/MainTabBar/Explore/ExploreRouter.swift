//   
//  ViperRouter.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import Foundation

protocol ExploreRouterType {
    func showWebViewerScreen(url: String)
}

final class ExploreRouter: ExploreRouterType {
    
    private weak var viewController: ExploreViewController?
    
    init(viewController: ExploreViewController) {
        self.viewController = viewController
    }
    
    func showWebViewerScreen(url: String) {
        let webViewerViewController = WebViewerViewController()
        let configurator: WebViewerConfiguratorType = WebViewerConfigurator(url: url)
        configurator.configure(viewController: webViewerViewController)
        viewController?.present(NewsNavigationController(rootViewController: webViewerViewController), animated: true)
    }
}
