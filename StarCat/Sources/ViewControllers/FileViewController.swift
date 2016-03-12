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

class FileViewController: UIViewController {

    let viewModel = FileViewModel()
    let bag = SubscriptionBag()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var textView: UITextView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = viewModel.name.value
        loadingIndicator.startAnimating()
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
        textHeightConstraint.constant = size.height
        textWidthConstraint.constant = size.width
        loadingIndicator.stopAnimating()
    }

}
