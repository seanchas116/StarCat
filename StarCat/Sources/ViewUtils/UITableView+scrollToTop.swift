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
            if source.numberOfSections!(in: self) > 0 {
                let top = IndexPath(row: NSNotFound, section: 0)
                scrollToRow(at: top, at: .top, animated: true)
            }
        }
    }
}
