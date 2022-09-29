//   
//  WebViewerPresenter.swift
//  News
//
//  Created by Aleksandr on 29.09.2022.
//

import Foundation

protocol WebViewerPresenterType {
    var request: URLRequest? { get }
    
    func didTapDoneButton()
}

class WebViewerPresenter: WebViewerPresenterType {
    
    private let interactor: WebViewerInteractorType
    private let router: WebViewerRouterType
    private weak var view: WebViewerViewType?
    
    var request: URLRequest? {
        guard let url = URL(string: interactor.url) else { return nil }
        
        return URLRequest(url: url)
    }
    
    init(interactor: WebViewerInteractorType,
         router: WebViewerRouterType,
         view: WebViewerViewType) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func didTapDoneButton() {
        router.dismissScreen()
    }
}
