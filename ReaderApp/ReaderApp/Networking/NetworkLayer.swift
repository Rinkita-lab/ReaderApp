//
//  NetworkLayer.swift
//  ReaderApp
//
//  Created by Rinkita Patil on 9/16/25.
//

import Alamofire

protocol ArticleServiceProtocol {
    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void)
}

class ArticleService: ArticleServiceProtocol {
    private let apiKey = "9f4e5778f3a94d8a9cede761bebcebf0"
    
    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        let url = "https://newsapi.org/v2/everything?q=technology&apiKey=\(apiKey)"
        
        AF.request(url).responseDecodable(of: NewsAPIResponse.self) { response in
            switch response.result {
            case .success(let newsResponse):
                completion(.success(newsResponse.articles))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct NewsAPIResponse: Codable {
    let articles: [Article]
}
