//
//  UIProgressView.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/08.
//
//

import Foundation

extension UIProgressView {
    public func wwProgress(animated: Bool) -> (Float) -> Void {
        return { [weak self] in
            self?.setProgress($0, animated: animated)
        }
    }
}
