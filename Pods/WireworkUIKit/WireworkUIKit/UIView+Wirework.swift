//
//  UIView.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/08.
//
//

import UIKit

extension UIView {
    public var wwAlpha: (CGFloat) -> Void {
        return { [weak self] in
            self?.alpha = $0
        }
    }
    
    public var wwBackgroundColor: (UIColor?) -> Void {
        return { [weak self] in
            self?.backgroundColor = $0
        }
    }
    
    public var wwHidden: (Bool) -> Void {
        return { [weak self] in
            self?.isHidden = $0
        }
    }
    
    public var wwUserInteractionEnabled: (Bool) -> Void {
        return { [weak self] in
            self?.isUserInteractionEnabled = $0
        }
    }
    
    public var wwTintColor: (UIColor?) -> Void {
        return { [weak self] in
            self?.tintColor = $0
        }
    }
}
