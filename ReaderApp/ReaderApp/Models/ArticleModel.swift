//
//  Models.swift
//  ReaderApp
//
//  Created by Rinkita Patil on 9/16/25.
//

import Foundation
import CoreData

// Simplified Article model
struct Article: Codable, Identifiable {
    let id = UUID()
    let title: String
    let author: String?
    let urlToImage: String?
    
    enum CodingKeys: String, CodingKey {
        case title, author, urlToImage
    }
}
