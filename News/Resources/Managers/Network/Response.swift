//
//  Response.swift
//  Weatherly
//
//  Created by Aleksandr on 25.09.2022.
//

import Foundation

enum Response<T: Decodable> {
    case success(T)
    case failure(ResponseError)
}

enum ResponseError: Error {
    case serverNotResponding
    case noInternetConnection
}
