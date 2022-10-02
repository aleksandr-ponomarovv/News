//
//  NewsService.swift
//  News
//
//  Created by Aleksandr on 25.09.2022.
//

import Alamofire

final class NewsService: APIManagerProtocol {
    
    func getEverything(searchText: String, page: Int, completion: @escaping(Response<ArticleEntity>) -> Void) {
        let api: NewsApi = .getEverything(searchText: searchText, page: page)
        AF.request(api).responseDecodable(of: ArticleEntity.self) { response in
            print("RESPONSE ENTITY: \(response.data?.json ?? "")")
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(self.errorHandling(error: error)))
            }
        }
    }
}
