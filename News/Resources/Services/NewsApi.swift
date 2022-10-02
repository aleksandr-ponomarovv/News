//
//  NewsApi.swift
//  News
//
//  Created by Aleksandr on 25.09.2022.
//

import Alamofire

enum NewsApi: URLRequestBuilder {
    
    case getEverything(searchText: String, page: Int)
    
    var path: String {
        switch self {
        case .getEverything:
            return "everything"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getEverything(let searchText, let page):
            return ["q": searchText, "page": page, "apiKey": Constants.key, "pageSize": Constants.pageSize]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getEverything:
            return .get
        }
    }
}
