//
//  RoundButton.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/04.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var highlightedBorderColor = UIColor.blueColor() {
        didSet {
            updateBorderColor()
        }
    }
    
    @IBInspectable
    var borderColor = UIColor.blackColor() {
        didSet {
            updateBorderColor()
        }
    }
    
    override var highlighted: Bool {
        get {
            return super.highlighted
        }
        set {
            super.highlighted = newValue
            updateBorderColor()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateBorderColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateBorderColor()
    }
    
    private func updateBorderColor() {
        if (highlighted) {
            layer.borderColor = titleColorForState(.Highlighted)?.CGColor
        } else {
            layer.borderColor = titleColorForState(.Normal)?.CGColor
        }
    }
}
