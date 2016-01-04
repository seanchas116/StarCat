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
    
    @IBInspectable
    var hasLeftBorder: Bool = true {
        didSet {
            updateBorderShape()
        }
    }
    
    @IBInspectable
    var hasRightBorder: Bool = true {
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
        let halfBorder = borderWidth * 0.5
        let path = UIBezierPath()
        let width = bounds.width
        let height = bounds.height
        let pi = CGFloat(M_PI)
        let cornerRadius = min(self.cornerRadius, width * 0.5)
        
        func addRightBorder() {
            path.addLineToPoint(CGPoint(x: width - cornerRadius, y: halfBorder))
            path.addArcWithCenter(CGPoint(x: width - cornerRadius, y: cornerRadius), radius: cornerRadius - halfBorder, startAngle: pi*1.5, endAngle: 0, clockwise: true)
            path.addLineToPoint(CGPoint(x: width - halfBorder, y: height - cornerRadius))
            path.addArcWithCenter(CGPoint(x: width - cornerRadius, y: height - cornerRadius), radius: cornerRadius - halfBorder, startAngle: 0, endAngle: pi*0.5, clockwise: true)
        }
        func addLeftBorder() {
            path.addLineToPoint(CGPoint(x: cornerRadius, y: height - halfBorder))
            path.addArcWithCenter(CGPoint(x: cornerRadius, y: height - cornerRadius), radius: cornerRadius - halfBorder, startAngle: pi*0.5, endAngle: pi, clockwise: true)
            path.addLineToPoint(CGPoint(x: halfBorder, y: cornerRadius))
            path.addArcWithCenter(CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius - halfBorder, startAngle: pi, endAngle: pi*1.5, clockwise: true)
        }
        
        switch (hasLeftBorder, hasRightBorder) {
        case (false, false):
            path.moveToPoint(CGPoint(x: 0, y: halfBorder))
            path.addLineToPoint(CGPoint(x: width, y: halfBorder))
            path.moveToPoint(CGPoint(x: width, y: height - halfBorder))
            path.addLineToPoint(CGPoint(x: 0, y: height - halfBorder))
        case (false, true):
            path.moveToPoint(CGPoint(x: 0, y: halfBorder))
            addRightBorder()
            path.addLineToPoint(CGPoint(x: 0, y: height - halfBorder))
        case (true, false):
            path.moveToPoint(CGPoint(x: width, y: height - halfBorder))
            addLeftBorder()
            path.addLineToPoint(CGPoint(x: width, y: halfBorder))
        case (true, true):
            path.moveToPoint(CGPoint(x: cornerRadius, y: halfBorder))
            addRightBorder()
            addLeftBorder()
        }
        borderLayer.path = path.CGPath
        borderLayer.lineWidth = borderWidth
    }
}
