//
//  UIActivityIndicatorView.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/08.
//
//

import UIKit

extension UIActivityIndicatorView {
    public var wwAnimating: (Bool) -> Void {
        return { [weak self] animating in
            if animating {
                self?.startAnimating()
            } else {
                self?.stopAnimating()
            }
        }
    }
}