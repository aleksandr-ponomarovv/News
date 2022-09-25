//   
//  NewsNavigationController.swift
//  News
//
//  Created by Aleksandr on 25.09.2022.
//

import UIKit

class NewsNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        navigationBar.prefersLargeTitles = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = backItem
        super.pushViewController(viewController, animated: animated)
    }
}
