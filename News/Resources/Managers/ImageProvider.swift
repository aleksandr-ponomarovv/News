//
//  ImageProvider.swift
//  News
//
//  Created by Aleksandr on 27.09.2022.
//

import UIKit

final class ImageProvider {
    static let shared = ImageProvider()
    
    private let concurrentQueue = DispatchQueue(label: "thread-safe-cache", attributes: .concurrent)
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func fetchImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let urlNSString = urlString as NSString
        
        getCache(urlNSString: urlNSString) { image in
            if let image = image {
                completion(image)
                return
            }
            
            guard let url = URL(string: urlString) else {
                completion(nil)
                return
            }
            
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    guard let image = UIImage(data: data) else {
                        completion(nil)
                        return
                    }
                    self.setCache(image: image, key: urlNSString)
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
    }
    
    func getCache(urlNSString: NSString, completion: @escaping (UIImage?) -> Void) {
        concurrentQueue.sync { [weak self] in
            guard let self = self else { return }
            
            completion(self.cache.object(forKey: urlNSString))
        }
    }
    
    func setCache(image: UIImage, key: NSString) {
        concurrentQueue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            
            self.cache.setObject(image, forKey: key)
        }
    }
}
