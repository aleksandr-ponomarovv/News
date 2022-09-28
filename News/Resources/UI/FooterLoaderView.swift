//
//  FooterLoaderView.swift
//  News
//
//  Created by Aleksandr on 28.09.2022.
//

import UIKit

final class FooterLoaderView: UIView {
    
    private lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.tintColor = .systemGray
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        return loader
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    func start() {
        loader.startAnimating()
    }
    
    func stop() {
        loader.startAnimating()
    }
}

// MARK: - Private Methods
private extension FooterLoaderView {
    func setupUI() {
        backgroundColor = .clear
        addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
