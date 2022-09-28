//   
//  ViperViewController.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import UIKit

protocol ExploreViewType: AnyObject {
    func updateTableView()
    func hideTableFooterView()
}

final class ExploreViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var footerView: UIView = {
        let view = FooterLoaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        view.start()
        return view
    }()
    
    var presenter: ExplorePresenterType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        presenter?.fetchNews(serchText: "tesla")
    }
}

// MARK: - ExploreViewType
extension ExploreViewController: ExploreViewType {
    func updateTableView() {
        hideTableFooterView()
        tableView.reloadData()
    }
    
    func hideTableFooterView() {
        tableView.tableFooterView = nil
    }
}

// MARK: - UIScrollViewDelegate
extension ExploreViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let presenter = presenter else { return }
        
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            if presenter.hasMoreNews {
                tableView.tableFooterView = footerView
                presenter.fetchNextPage()
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ExploreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(cellType: ArticleTableViewCell.self, for: indexPath)
        cell.model = presenter?.articleCellModel(at: indexPath)
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
