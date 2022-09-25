//
//  Data+Extension.swift
//  News
//
//  Created by Aleksandr on 26.09.2022.
//

import Foundation

extension Data {
    var json: Any? {
        return try? JSONSerialization.jsonObject(with: self, options: .mutableContainers)
    }
}
