//
//  ColorizedImageView.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/18.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit

@IBDesignable
class ColorizedImageView: UIImageView {
    
    @IBInspectable
    var colorizedImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    @IBInspectable
    var color: UIColor = UIColor.blackColor() {
        didSet {
            updateImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        updateImage()
    }
    
    
    private func updateImage() {
        image = colorizedImage?.imageWithRenderingMode(.AlwaysTemplate)
        tintColor = color
    }
}
