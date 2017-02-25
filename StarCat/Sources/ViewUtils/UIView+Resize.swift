//
//  UIView+Resize.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/03/04.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit

extension UIView {
    func resizeHeightToMinimum() {
        let minimum = systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        frame = CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: minimum.height))
    }
}
