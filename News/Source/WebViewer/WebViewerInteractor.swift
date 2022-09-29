//   
//  WebViewerInteractor.swift
//  News
//
//  Created by Aleksandr on 29.09.2022.
//

import Foundation

protocol WebViewerInteractorType {
    var url: String { get }
}

class WebViewerInteractor: WebViewerInteractorType {
    
    let url: String
    
    init(url: String) {
        self.url = url
    }
}
