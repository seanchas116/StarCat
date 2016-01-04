//
//  RoundButtonBorder.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/04.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButtonBorder: UIView {
    private let shapeLayer = CAShapeLayer()
    
    @IBInspectable
    var borderWidth: CGFloat = 1 {
        didSet {
            updateShape()
        }
    }
    
    @IBInspectable
    var spacing: CGFloat = 3 {
        didSet {
            updateShape()
        }
    }
    
    @IBInspectable
    var color: UIColor = UIColor.blackColor() {
        didSet {
            updateColor()
        }
    }
    
    @IBInspectable
    var highlightedColor: UIColor = UIColor.blueColor() {
        didSet {
            updateColor()
        }
    }
    
    @IBInspectable
    var highlighted: Bool = false {
        didSet {
            updateColor()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            updateShape()
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
        updateColor()
        updateShape()
        layer.backgroundColor = UIColor.clearColor().CGColor
        shapeLayer.lineCap = kCALineCapButt
        layer.addSublayer(shapeLayer)
    }
    
    private func updateColor() {
        shapeLayer.strokeColor = (highlighted ? highlightedColor : color).CGColor
    }
    
    private func updateShape() {
        let path = UIBezierPath()
        let center = bounds.width * 0.5
        let height = bounds.height
        path.moveToPoint(CGPoint(x: center, y: 0))
        path.addLineToPoint(CGPoint(x: center, y: borderWidth))
        path.moveToPoint(CGPoint(x: center, y: borderWidth + spacing))
        path.addLineToPoint(CGPoint(x: center, y: height - borderWidth - spacing))
        path.moveToPoint(CGPoint(x: center, y: height - borderWidth))
        path.addLineToPoint(CGPoint(x: center, y: height))
        shapeLayer.path = path.CGPath
        shapeLayer.lineWidth = bounds.width
    }
}
