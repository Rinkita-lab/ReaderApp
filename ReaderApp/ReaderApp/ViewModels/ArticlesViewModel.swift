//
//  NetworkLayer.swift
//  ReaderApp
//
//  Created by Rinkita Patil on 9/16/25.
//

import Foundation
import CoreData

class ArticlesViewModel {
    private var allArticles: [Article] = []
    private let articleService: ArticleServiceProtocol
    private let context = CoreDataStack.shared.context
    
    var filteredArticles: [Article] = []
    var onUpdate: (() -> Void)?
    
    init(service: ArticleServiceProtocol = ArticleService()) {
        self.articleService = service
    }
    
    func fetchArticles() {
        articleService.fetchArticles { [weak self] result in
            switch result {
            case .success(let articles):
                self?.allArticles = articles
                self?.filteredArticles = articles
                self?.cacheArticles(articles)
                self?.onUpdate?()
            case .failure:
                self?.loadCachedArticles()
                self?.onUpdate?()
            }
        }
    }
    
    private func cacheArticles(_ articles: [Article]) {
        // Clear old cache first (optional)
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        if let results = try? context.fetch(fetchRequest) {
            for obj in results {
                context.delete(obj)
            }
        }
        
        for article in articles {
            let entity = ArticleEntity(context: context)
            entity.title = article.title
            entity.author = article.author
            entity.imageUrl = article.urlToImage
            entity.isBookmarked = false
        }
        
        CoreDataStack.shared.saveContext()
    }
    
    private func loadCachedArticles() {
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        if let results = try? context.fetch(fetchRequest) {
            self.filteredArticles = results.map {
                Article(title: $0.title ?? "", author: $0.author, urlToImage: $0.imageUrl)
            }
            self.allArticles = filteredArticles
        }
    }
    
    func filterArticles(by query: String) {
        if query.isEmpty {
            filteredArticles = allArticles
        } else {
            filteredArticles = allArticles.filter { $0.title.localizedCaseInsensitiveContains(query) }
        }
        onUpdate?()
    }
    
    func toggleBookmark(for article: Article) {
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", article.title)
        
        if let results = try? context.fetch(fetchRequest), let entity = results.first {
            entity.isBookmarked.toggle()
        } else {
            // If not in Core Data yet, create it as bookmarked
            let entity = ArticleEntity(context: context)
            entity.title = article.title
            entity.author = article.author
            entity.imageUrl = article.urlToImage
            entity.isBookmarked = true
        }
        
        CoreDataStack.shared.saveContext()
    }

    
    func loadBookmarkedArticles() -> [Article] {
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isBookmarked == true")
        
        if let results = try? context.fetch(fetchRequest) {
            return results.map {
                Article(title: $0.title ?? "", author: $0.author, urlToImage: $0.imageUrl)
            }
        }
        return []
    }
    func isBookmarked(article: Article) -> Bool {
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", article.title)
        if let result = try? context.fetch(fetchRequest).first {
            return result.isBookmarked
        }
        return false
    }

}
