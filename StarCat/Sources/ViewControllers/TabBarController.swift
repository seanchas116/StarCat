//
//  TabBarController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2015/12/22.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        centerTabBarItems()
        UITabBar.appearance().tintColor = UIColor.whiteColor()
    }
    func centerTabBarItems() {
        for vc in viewControllers! {
            vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        }
    }
}