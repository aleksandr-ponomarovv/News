//   
//  NewsNavigationController.swift
//  News
//
//  Created by Aleksandr on 25.09.2022.
//

import UIKit

class NewsNavigationController: UINavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let backItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = backItem
        super.pushViewController(viewController, animated: animated)
    }
}
