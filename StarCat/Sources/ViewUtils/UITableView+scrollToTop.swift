//
//  UITableViewController+scrollToTop.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/12.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func scrollToTop() {
        setContentOffset(CGPoint(x: 0, y: -contentInset.top), animated: true)
    }
}
