//   
//  WebViewerViewController.swift
//  News
//
//  Created by Aleksandr on 29.09.2022.
//

import UIKit
import WebKit

protocol WebViewerViewType: AnyObject {
    func loadWebView()
}

class WebViewerViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!
    
    var presenter: WebViewerPresenterType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

// MARK: - WebViewerViewType
extension WebViewerViewController: WebViewerViewType {
    @objc func loadWebView() {
        guard let request = presenter?.request else { return }
        
        webView.load(request)
    }
}

// MARK: - Private methods
private extension WebViewerViewController {
    func configureUI() {
        loadWebView()
        setupNavigationItems()
    }
    
    // MARK: - Navigation
    
    func setupNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                           target: self,
                                                           action: #selector(loadWebView))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapDoneButton))
    }
    
    @objc func didTapDoneButton() {
        presenter?.didTapDoneButton()
    }
}
