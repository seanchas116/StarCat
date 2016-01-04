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
    var borderWidth: CGFloat = 1 {
        didSet {
            updateBorderShape()
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            updateBorderShape()
        }
    }
    
    override var highlighted: Bool {
        didSet {
            updateBorderColor()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            updateBorderShape()
        }
    }
    
    let borderLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        borderLayer.fillColor = UIColor.clearColor().CGColor
        layer.addSublayer(borderLayer)
        updateBorderColor()
        updateBorderShape()
    }
    
    private func updateBorderColor() {
        let borderColor = (highlighted ? titleColorForState(.Highlighted) : titleColorForState(.Normal))?.CGColor
        borderLayer.strokeColor = borderColor
    }
    
    private func updateBorderShape() {
        let roundingCorners: UIRectCorner = [.TopRight, .TopLeft, .BottomRight, .BottomLeft]
        borderLayer.path = UIBezierPath(
            roundedRect: bounds.insetBy(dx: borderWidth * 0.5, dy: borderWidth * 0.5),
            byRoundingCorners: roundingCorners,
            cornerRadii: CGSizeMake(cornerRadius, cornerRadius)
        ).CGPath
        borderLayer.lineWidth = borderWidth
    }
}
