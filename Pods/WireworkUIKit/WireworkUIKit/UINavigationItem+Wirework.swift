//
//  UINavigationItem.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/08.
//
//

import UIKit

extension UINavigationItem {
    public var wwTitle: (String?) -> Void {
        return { [weak self] in
            self?.title = $0
        }
    }
}
