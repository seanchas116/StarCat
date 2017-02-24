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
    var selectedBackgroundColor: UIColor! = UIColor.clear {
        didSet {
            updateColor()
        }
    }
    
    @IBInspectable
    var borderColor: UIColor! = UIColor.black {
        didSet {
            updateColor()
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 1 {
        didSet {
            updateShape()
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            updateShape()
        }
    }
    
    @IBInspectable
    var hasLeftBorder: Bool = true {
        didSet {
            updateShape()
        }
    }
    
    @IBInspectable
    var hasRightBorder: Bool = true {
        didSet {
            updateShape()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateColor()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            updateShape()
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
        borderLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(borderLayer)
        updateColor()
        updateShape()
    }
    
    private func updateColor() {
        borderLayer.strokeColor = borderColor.cgColor
        
        if isSelected {
            borderLayer.fillColor = selectedBackgroundColor.cgColor
        } else {
            borderLayer.fillColor = nil
        }
    }
    
    private func updateShape() {
        let roundingCorners: UIRectCorner = [.topRight, .topLeft, .bottomRight, .bottomLeft]
        let halfBorder = borderWidth * 0.5
        let path = UIBezierPath()
        let width = bounds.width
        let height = bounds.height
        let pi = CGFloat(M_PI)
        let cornerRadius = min(self.cornerRadius, width * 0.5)
        
        func addRightBorder() {
            path.addLine(to: CGPoint(x: width - cornerRadius, y: halfBorder))
            path.addArc(withCenter: CGPoint(x: width - cornerRadius, y: cornerRadius), radius: cornerRadius - halfBorder, startAngle: pi*1.5, endAngle: 0, clockwise: true)
            path.addLine(to: CGPoint(x: width - halfBorder, y: height - cornerRadius))
            path.addArc(withCenter: CGPoint(x: width - cornerRadius, y: height - cornerRadius), radius: cornerRadius - halfBorder, startAngle: 0, endAngle: pi*0.5, clockwise: true)
        }
        func addLeftBorder() {
            path.addLine(to: CGPoint(x: cornerRadius, y: height - halfBorder))
            path.addArc(withCenter: CGPoint(x: cornerRadius, y: height - cornerRadius), radius: cornerRadius - halfBorder, startAngle: pi*0.5, endAngle: pi, clockwise: true)
            path.addLine(to: CGPoint(x: halfBorder, y: cornerRadius))
            path.addArc(withCenter: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius - halfBorder, startAngle: pi, endAngle: pi*1.5, clockwise: true)
        }
        
        switch (hasLeftBorder, hasRightBorder) {
        case (false, false):
            path.move(to: CGPoint(x: 0, y: halfBorder))
            path.addLine(to: CGPoint(x: width, y: halfBorder))
            path.move(to: CGPoint(x: width, y: height - halfBorder))
            path.addLine(to: CGPoint(x: 0, y: height - halfBorder))
        case (false, true):
            path.move(to: CGPoint(x: 0, y: halfBorder))
            addRightBorder()
            path.addLine(to: CGPoint(x: 0, y: height - halfBorder))
        case (true, false):
            path.move(to: CGPoint(x: width, y: height - halfBorder))
            addLeftBorder()
            path.addLine(to: CGPoint(x: width, y: halfBorder))
        case (true, true):
            path.move(to: CGPoint(x: cornerRadius, y: halfBorder))
            addRightBorder()
            addLeftBorder()
        }
        borderLayer.path = path.cgPath
        borderLayer.lineWidth = borderWidth
    }
}
