//
//  ArticleEntity.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import Foundation

// MARK: - ArticleEntity
final class ArticleEntity: Decodable {
    let status: String
    let totalResults: Int
    var articles: [Article]

    init(status: String, totalResults: Int, articles: [Article]) {
        self.status = status
        self.totalResults = totalResults
        self.articles = articles
    }
}

// MARK: - Article
final class Article: ArticleTableViewCellModel, Decodable {
    let source: Source
    let author: String?
    let title, articleDescription: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String

    var subtitle: String {
        "\(publishedAt) \(source.name)"
    }

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }

    init(source: Source, author: String?, title: String, articleDescription: String, url: String, urlToImage: String, publishedAt: String, content: String) {
        self.source = source
        self.author = author
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }
}

// MARK: - Source
final class Source: Decodable {
    let identifire: String?
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case identifire = "id"
        case name
    }

    init(identifire: String?, name: String) {
        self.identifire = identifire
        self.name = name
    }
}
