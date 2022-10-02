//   
//  ViperViewController.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import UIKit

protocol ExploreViewType: AnyObject {
    func updateTableView()
    func hideTableIndicators()
}

final class ExploreViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var refreshControl: UIRefreshControl = {
        var refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        return refresh
    }()
    
    private lazy var footerView: UIView = {
        let view = FooterLoaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        view.start()
        return view
    }()
    
    var presenter: ExplorePresenterType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
        configureUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
}

// MARK: - ExploreViewType
extension ExploreViewController: ExploreViewType {
    func updateTableView() {
        hideTableIndicators()
        tableView.reloadData()
    }
    
    func hideTableIndicators() {
        tableView.tableFooterView = nil
        tableView.refreshControl?.endRefreshing()
    }
}

// MARK: - UISearchBarDelegate
extension ExploreViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.fetchNews(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter?.fetchNews(searchText: searchBar.text ?? "")
        view.endEditing(true)
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
        cell.favoriteButtonCompletion = presenter?.favoriteButtonCompletion(at: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ExploreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectArticle(at: indexPath)
    }
}

// MARK: - Private methods
private extension ExploreViewController {
    func configureUI() {
        setupSearchBar()
        setupTableView()
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search News"
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellNibType: ArticleTableViewCell.self)
        tableView.refreshControl = refreshControl
        tableView.keyboardDismissMode = .onDrag
    }
    
    @objc func refreshAction() {
        presenter?.refreshAction(searchText: searchBar.text)
    }
}
