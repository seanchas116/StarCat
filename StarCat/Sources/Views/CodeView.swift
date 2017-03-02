//
//  CodeView.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/03/14.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import PromiseKit
import Wirework
import UIColor_Hex_Swift

private let highlightCSS = getBundleFile("xcode", ofType: "css")

class CodeView: UIView {
    private let textView = UITextView()
    private let lineNumbersView = UITextView()
    private let border = CALayer()
    private var size = CGSize(width: 0, height: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        textView.isEditable = false
        textView.isScrollEnabled = false
        lineNumbersView.isSelectable = false
        lineNumbersView.isEditable = false
        lineNumbersView.isScrollEnabled = false
        border.backgroundColor = UIColor("#F1F1F1").cgColor
        addSubview(textView)
        addSubview(lineNumbersView)
        layer.addSublayer(border)
    }

    func loadContent(_ content: String, name: String) -> Promise<Void> {
        let textPromise = highlighter.highlight(value: content, name: name)
            .then(on: .global()) { highlighted in
                renderAttributedStringFromHTML("<pre><code>\(highlighted)</code></pre>",
                    css: highlightCSS + " code { font-family: Menlo; } ")
        }
        let lineNumbersPromise: Promise<NSAttributedString?> = DispatchQueue.global().promise {
            let count = content.countLines()
            let digits = count.digitsCount
            let text = (1...count).map { String($0).fillLeft(min: digits, by: " ") }.joined(separator: "\n")
            return renderAttributedStringFromHTML("<pre><code>\(text)</code></pre>",
                css: " code { font-family: Menlo; color: 9B9B9B; } ")
        }
        return when(fulfilled: textPromise, lineNumbersPromise).then { (text, lineNumbers) -> Void in
            self.textView.attributedText = text
            self.lineNumbersView.attributedText = lineNumbers
            self.adjustSizes()
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        return size
    }
    
    private func adjustSizes() {
        super.layoutSubviews()
        
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let textSize = textView.sizeThatFits(maxSize)
        let lineNumbersSize = lineNumbersView.sizeThatFits(maxSize)
        
        size = CGSize(width: lineNumbersSize.width + 6 + textSize.width, height: textSize.height)
        
        lineNumbersView.frame = CGRect(x: 0, y: 0, width: lineNumbersSize.width, height: lineNumbersSize.height)
        textView.frame = CGRect(x: lineNumbersSize.width + 6, y: 0, width: textSize.width, height: textSize.height)
        
        frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        border.frame = CGRect(x: lineNumbersSize.width + 2, y: 0, width: 2, height: textSize.height)
        CATransaction.commit()
    }
}
