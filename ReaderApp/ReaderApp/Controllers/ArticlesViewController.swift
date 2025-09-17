//
//  ArticlesViewController.swift
//  ReaderApp
//
//  Created by Rinkita Patil on 9/16/25.
//

//
//  ArticlesViewController.swift
//  ReaderApp
//

import UIKit
import SDWebImage

class ArticlesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    let viewModel = ArticlesViewModel()
    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupSearchController()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
        
        viewModel.fetchArticles()
    }
    
    func setupTableView() {
        tableView.frame = view.bounds
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refreshArticles), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        view.addSubview(tableView)
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search articles..."
        
        // 👇 This makes the search bar appear in the nav bar
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    @objc func refreshArticles() {
        viewModel.fetchArticles()
    }
    
    // MARK: - UITableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleCell else {
            return UITableViewCell()
        }
        let article = viewModel.filteredArticles[indexPath.row]
        
        // Fetch bookmark state from Core Data
        let isBookmarked = viewModel.isBookmarked(article: article)
        
        cell.configure(with: article, isBookmarked: isBookmarked)
        cell.onBookmarkTapped = { [weak self] in
            self?.viewModel.toggleBookmark(for: article)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }

        
        return cell
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        viewModel.filterArticles(by: searchText)
    }
}
