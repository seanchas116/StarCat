//
//  UIViewController+storyboard.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/30.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import PromiseKit

extension UIViewController {
    func presentStoryboard(name: String, animated: Bool) -> Promise<UIViewController> {
        return Promise { resolve, reject in
            let storyboard = UIStoryboard(name: name, bundle: nil)
            let next = storyboard.instantiateInitialViewController()!
            presentViewController(next, animated: animated) {
                resolve(next)
            }
        }
    }
}