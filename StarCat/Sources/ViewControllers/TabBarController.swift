//
//  TabBarController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2015/12/22.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import UIKit

extension UINavigationController {
    func scrollRootToTop() {
        if viewControllers.count == 1 {
            let root = viewControllers[0].view
            if let table = root as? UITableView {
                table.scrollToTop()
            }
        }
    }
}

class TabBarController: UITabBarController {
    
    var lastSelectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerTabBarItems()
        UITabBar.appearance().tintColor = UIColor.white
    }
    
    func centerTabBarItems() {
        for vc in viewControllers! {
            vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items!.index(of: item) {
            if lastSelectedIndex == index {
                tabBarDoubleTapped(index: index)
            }
            lastSelectedIndex = index
        }
    }
    
    private func tabBarDoubleTapped(index: Int) {
        if let nav = selectedViewController as? UINavigationController {
            nav.scrollRootToTop()
        }
    }
}
