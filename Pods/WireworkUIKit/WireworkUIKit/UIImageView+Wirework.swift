//
//  UIImageView.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/08.
//
//

import UIKit

extension UIImageView {
    public var wwImage: (UIImage?) -> Void {
        return { [weak self] in
            self?.image = $0
        }
    }
    
    public var wwHighlightedImage: (UIImage?) -> Void {
        return { [weak self] in
            self?.highlightedImage = $0
        }
    }
}
