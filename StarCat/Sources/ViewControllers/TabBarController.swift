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
    var viewModel = AppViewModel.instance.tabViewModel
    
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
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if let index = tabBar.items!.indexOf(item) {
            if lastSelectedIndex == index {
                tabBarDoubleTapped(index)
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
