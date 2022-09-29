//   
//  WebViewerRouter.swift
//  News
//
//  Created by Aleksandr on 29.09.2022.
//

import Foundation

protocol WebViewerRouterType {
    func dismissScreen()
}

class WebViewerRouter: WebViewerRouterType {
    
    private weak var viewController: WebViewerViewController?
    
    init(viewController: WebViewerViewController) {
        self.viewController = viewController
    }
    
    func dismissScreen() {
        viewController?.dismiss(animated: true)
    }
}
