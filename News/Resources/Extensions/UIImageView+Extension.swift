//
//  UIImageView+Extension.swift
//  News
//
//  Created by Aleksandr on 27.09.2022.
//

import UIKit

extension UIImageView {
    func imageFromUrl(urlString: String) {
        ImageProvider.shared.fetchImage(urlString: urlString) { image in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.image = image
            }
        }
    }
}
