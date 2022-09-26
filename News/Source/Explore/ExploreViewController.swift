//   
//  ViperViewController.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import UIKit

protocol ExploreViewType: AnyObject {}

class ExploreViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: ExplorePresenterType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

// MARK: - ExploreViewType
extension ExploreViewController: ExploreViewType {}

// MARK: - UITableViewDataSource
extension ExploreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: ArticleTableViewCell.self, for: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ExploreViewController: UITableViewDelegate {
    
}

// MARK: - Private methods
private extension ExploreViewController {
    func configureUI() {
        setupTableView()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellNibType: ArticleTableViewCell.self)
    }
}
