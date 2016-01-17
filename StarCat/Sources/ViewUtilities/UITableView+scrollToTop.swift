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
        if let source = dataSource {
            if source.numberOfSectionsInTableView!(self) > 0 {
                let top = NSIndexPath(forRow: NSNotFound, inSection: 0)
                scrollToRowAtIndexPath(top, atScrollPosition: .Top, animated: true)
            }
        }
    }
}