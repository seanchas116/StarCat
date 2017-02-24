//
//  UIBarItem.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/08.
//
//

import UIKit

extension UIBarItem {
    public var wwTitle: (String?) -> Void {
        return { [weak self] in
            self?.title = $0
        }
    }
    
    public var wwImage: (UIImage?) -> Void {
        return { [weak self] in
            self?.image = $0
        }
    }
    
    public var wwEnabled: (Bool) -> Void {
        return { [weak self] in
            self?.isEnabled = $0
        }
    }
}
