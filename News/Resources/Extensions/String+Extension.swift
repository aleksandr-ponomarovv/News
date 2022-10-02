//
//  String+Extension.swift
//  News
//
//  Created by Aleksandr on 29.09.2022.
//

import Foundation

extension String {
    func toFormattedDate(from: String = "yyyy-MM-dd'T'HH:mm:ssZ", to: String = "dd-MM-yyyy") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = from
        
        guard let date = dateFormatter.date(from: self) else { return nil }
        dateFormatter.dateFormat = to
        return dateFormatter.string(from: date)
    }
}
