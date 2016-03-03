//
//  UIViewController+Wirework.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/18.
//
//

import UIKit

extension UIViewController {
    public var wwTitle: (String?) -> Void {
        return { [weak self] in
            self?.title = $0
        }
    }
}
