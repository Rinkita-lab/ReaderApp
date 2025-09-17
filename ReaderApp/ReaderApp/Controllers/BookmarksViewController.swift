//
//  Untitled.swift
//  ReaderApp
//
//  Created by Rinkita Patil on 9/16/25.
//

import UIKit
import SDWebImage

class BookmarksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    var bookmarkedArticles: [Article] = []
    let viewModel = ArticlesViewModel() // reusing view model for bookmarks
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bookmarks"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        loadBookmarks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBookmarks()
    }
    
    func setupTableView() {
        tableView.frame = view.bounds
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    
    func loadBookmarks() {
        bookmarkedArticles = viewModel.loadBookmarkedArticles()
        tableView.reloadData()
    }
    
    // UITableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkedArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as? ArticleCell else {
            return UITableViewCell()
        }
        
        let article = bookmarkedArticles[indexPath.row]
        let isBookmarked = viewModel.isBookmarked(article: article)
        cell.configure(with: article, isBookmarked: isBookmarked)

        cell.onBookmarkTapped = { [weak self] in
            self?.viewModel.toggleBookmark(for: article)
            self?.loadBookmarks() // refresh the bookmarks list
        }

        return cell
    }
}
