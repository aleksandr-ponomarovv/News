//   
//  WebViewerConfigurator.swift
//  News
//
//  Created by Aleksandr on 29.09.2022.
//

import Foundation

protocol WebViewerConfiguratorType {
    func configure(viewController: WebViewerViewController)
}

class WebViewerConfigurator: WebViewerConfiguratorType {
    
    private let url: String
    
    init(url: String) {
        self.url = url
    }
    
    func configure(viewController: WebViewerViewController) {
        let interactor = WebViewerInteractor(url: url)
        let router = WebViewerRouter(viewController: viewController)
        let presenter = WebViewerPresenter(interactor: interactor, router: router, view: viewController)
        viewController.presenter = presenter
    }
}
