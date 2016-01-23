//
//  UINavigationController+.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/16.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func pushStoryboard(name: String, animated: Bool, config: (UIViewController) -> Void) {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let next = storyboard.instantiateInitialViewController() {
            config(next)
            pushViewController(next, animated: animated)
        }
    }
}