//
//  FileViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/03/06.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import PromiseKit
import Wirework


private let highlightCSS = getBundleFile("highlight.xcode.min", ofType: "css")

class ContentViewManager {
    let textView = UITextView()
    let lineNumbersView = UITextView()
    let view = UIView()
    
    init() {
        textView.editable = false
        textView.scrollEnabled = false
        lineNumbersView.editable = false
        lineNumbersView.scrollEnabled = false
        view.addSubview(textView)
        view.addSubview(lineNumbersView)
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
                css: " code { font-family: Menlo; } ")
        }
        return when(textPromise, lineNumbersPromise).then { (text, lineNumbers) -> Void in
            self.textView.attributedText = text
            self.lineNumbersView.attributedText = lineNumbers
            self.adjustSize()
        }
    }
    
    func adjustSize() {
        let maxSize = CGSizeMake(CGFloat.max, CGFloat.max)
        let size = self.textView.sizeThatFits(maxSize)
        let lineNumbersWidth = self.lineNumbersView.sizeThatFits(maxSize).width
        
        self.lineNumbersView.frame = CGRectMake(0, 0, lineNumbersWidth, size.height)
        self.textView.frame = CGRectMake(lineNumbersWidth, 0, size.width, size.height)
        self.view.frame = CGRectMake(0, 0, lineNumbersWidth + size.width, size.height)
    }
}

class FileViewController: UIViewController, UIScrollViewDelegate {

    let viewModel = FileViewModel()
    let bag = SubscriptionBag()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    private let contentViewManager = ContentViewManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.addSubview(contentViewManager.view)
        
        loadingIndicator.startAnimating()
        
        let name = viewModel.name.value
        viewModel.loadContent().then { content -> Void in
            let text = String(data: content, encoding: NSUTF8StringEncoding)
            if let text = text {
                self.contentViewManager.loadContent(text, name: name).then { _ -> Void in
                    self.scrollView.contentSize = self.contentViewManager.view.frame.size
                    self.loadingIndicator.stopAnimating()
                }
            }
        }
        viewModel.name.bindTo(wwTitle).addTo(bag)
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return contentViewManager.view
    }
}
