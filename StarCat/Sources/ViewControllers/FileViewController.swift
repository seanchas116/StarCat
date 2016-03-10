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


private let githubHighlightCSS = getBundleFile("highlight.github.min", ofType: "css")

class FileViewController: UIViewController {

    let viewModel = FileViewModel()
    let bag = SubscriptionBag()
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = viewModel.name.value
        viewModel.loadContent().then { content -> Void in
            let text = String(data: content, encoding: NSUTF8StringEncoding)
            if let text = text {
                Promise(highlight(text, name: name))
                    .thenInBackground { highlighted in
                        renderAttributedStringFromHTML("<pre><code>\(highlighted)</code></pre>", css: githubHighlightCSS)
                    }.then { [weak self] (text: NSAttributedString?) -> Void in
                        self?.textView.attributedText = text
                    }
            }
        }
    }
}
