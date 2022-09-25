//
//  NewsApi.swift
//  News
//
//  Created by Aleksandr on 25.09.2022.
//

import Alamofire

enum NewsApi: URLRequestBuilder {
    
    case getEverything(serchText: String, page: Int)
    
    var path: String {
        switch self {
        case .getEverything:
            return "everything"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getEverything(let serchText, let page):
            return ["q": serchText, "page": page, "apiKey": Constants.key, "pageSize": Constants.pageSize]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getEverything:
            return .get
        }
    }
}
