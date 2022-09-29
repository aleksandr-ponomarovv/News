//   
//  FavoritesViewController.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import UIKit

protocol FavoritesViewType: AnyObject {
    func reloadTableView()
}

final class FavoritesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: FavoritesPresenterType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

// MARK: - FavoritesViewType
extension FavoritesViewController: FavoritesViewType {
    func reloadTableView() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: ArticleTableViewCell.self, for: indexPath)
        cell.model = presenter?.articleCellModel(at: indexPath)
        cell.favoriteButtonCompletion = presenter?.favoriteButtonCompletion(at: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
    
}

// MARK: - Private methods
private extension FavoritesViewController {
    func configureUI() {
        setupTableView()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellNibType: ArticleTableViewCell.self)
    }
}
