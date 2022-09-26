//   
//  FavoritesViewController.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import UIKit

protocol FavoritesViewType: AnyObject {}

class FavoritesViewController: UIViewController {

    var presenter: FavoritesPresenterType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

// MARK: - FavoritesViewType
extension FavoritesViewController: FavoritesViewType {}

// MARK: - Private methods
private extension FavoritesViewController {
    func configureUI() {
        
    }
}
