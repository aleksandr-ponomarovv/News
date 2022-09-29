//
//  ArticleEntity.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import RealmSwift
import Realm

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
@objcMembers final class Article: Object, ArticleTableViewCellModel, Decodable {
    dynamic var url: String = ""
    
    dynamic var source: Source? = .init()
    dynamic var author: String? = ""
    dynamic var title: String = ""
    dynamic var articleDescription: String = ""
    dynamic var urlToImage: String = ""
    dynamic var publishedAt: String = ""
    dynamic var content: String = ""
    dynamic var isFavorite: Bool = false
    
    var sourceName: String? {
        source?.name
    }
    
    var date: String? {
        publishedAt.toFormatedDate()
    }

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }

    override class func primaryKey() -> String? {
        return "url"
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
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        url = try container.decode(String.self, forKey: .url)
        source = try container.decode(Source.self, forKey: .source)
        author = try? container.decode(String.self, forKey: .author)
        title = try container.decode(String.self, forKey: .title)
        articleDescription = try container.decode(String.self, forKey: .articleDescription)
        urlToImage = try container.decode(String.self, forKey: .urlToImage)
        publishedAt = try container.decode(String.self, forKey: .publishedAt)
        content = try container.decode(String.self, forKey: .content)
    }
    
    required override init() {
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        super.init()
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init()
    }
}

// MARK: - Source
@objcMembers final class Source: Object, Decodable {
    dynamic var identifire: String? = ""
    dynamic var name: String = ""
    
    enum CodingKeys: String, CodingKey {
        case identifire = "id"
        case name
    }

    override class func primaryKey() -> String? {
        return "name"
    }
    
    init(identifire: String?, name: String) {
        self.identifire = identifire
        self.name = name
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifire = try? container.decode(String.self, forKey: .identifire)
        name = try container.decode(String.self, forKey: .name)
    }
    
    required override init() {
        super.init()
    }

    required init(value: Any, schema: RLMSchema) {
        super.init()
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init()
    }
}
