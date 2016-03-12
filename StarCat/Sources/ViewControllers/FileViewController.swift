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

class FileViewController: UIViewController, UIScrollViewDelegate {

    let viewModel = FileViewModel()
    let bag = SubscriptionBag()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var textView: UITextView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.addSubview(textView)
        
        loadingIndicator.startAnimating()
        
        let name = viewModel.name.value
        viewModel.loadContent().then { content -> Void in
            let text = String(data: content, encoding: NSUTF8StringEncoding)
            if let text = text {
                highlighter.highlight(text, name: name)
                    .thenInBackground { highlighted in
                        renderAttributedStringFromHTML("<pre><code>\(highlighted)</code></pre>", css: highlightCSS + " code { font-family: Menlo; } ")
                    }.then { [weak self] in
                        self?.setText($0)
                    }
            }
        }
        viewModel.name.bindTo(wwTitle).addTo(bag)
    }
    
    func setText(text: NSAttributedString?) {
        textView.attributedText = text
        let size = textView.sizeThatFits(CGSizeMake(CGFloat.max, CGFloat.max))
        textView.frame = CGRect(origin: CGPoint.zero, size: size)
        scrollView.contentSize = size
        loadingIndicator.stopAnimating()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return textView
    }
}
