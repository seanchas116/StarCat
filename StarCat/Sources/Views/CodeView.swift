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

private let highlightCSS = getBundleFile("highlight.xcode.min", ofType: "css")

class CodeView: UIView {
    private let textView = UITextView()
    private let lineNumbersView = UITextView()
    private let border = CALayer()
    private var size = CGSizeMake(0, 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        textView.editable = false
        textView.scrollEnabled = false
        lineNumbersView.selectable = false
        lineNumbersView.editable = false
        lineNumbersView.scrollEnabled = false
        border.backgroundColor = UIColor(rgba: "#F1F1F1").CGColor
        addSubview(textView)
        addSubview(lineNumbersView)
        layer.addSublayer(border)
    }

    func loadContent(content: String, name: String) -> Promise<Void> {
        let textPromise = highlighter.highlight(content, name: name)
            .thenInBackground { highlighted in
                renderAttributedStringFromHTML("<pre><code>\(highlighted)</code></pre>",
                    css: highlightCSS + " code { font-family: Menlo; } ")
        }
        let lineNumbersPromise: Promise<NSAttributedString?> = dispatch_promise {
            let count = content.countLines()
            let digits = count.digitsCount
            let text = (1...count).map { String($0).fillLeft(digits, by: " ") }.joinWithSeparator("\n")
            return renderAttributedStringFromHTML("<pre><code>\(text)</code></pre>",
                css: " code { font-family: Menlo; color: 9B9B9B; } ")
        }
        return when(textPromise, lineNumbersPromise).then { (text, lineNumbers) -> Void in
            self.textView.attributedText = text
            self.lineNumbersView.attributedText = lineNumbers
            self.adjustSizes()
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        return size
    }
    
    private func adjustSizes() {
        super.layoutSubviews()
        
        let maxSize = CGSizeMake(CGFloat.max, CGFloat.max)
        let textSize = textView.sizeThatFits(maxSize)
        let lineNumbersSize = lineNumbersView.sizeThatFits(maxSize)
        
        size = CGSizeMake(lineNumbersSize.width + 6 + textSize.width, textSize.height)
        
        lineNumbersView.frame = CGRectMake(0, 0, lineNumbersSize.width, lineNumbersSize.height)
        textView.frame = CGRectMake(lineNumbersSize.width + 6, 0, textSize.width, textSize.height)
        
        frame = CGRectMake(0, 0, size.width, size.height)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        border.frame = CGRectMake(lineNumbersSize.width + 2, 0, 2, textSize.height)
        CATransaction.commit()
    }
}
