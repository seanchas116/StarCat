//
//  FileViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/03/06.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import JavaScriptCore
import Wirework

private let highlightJS = getBundleFile("highlight", ofType: "js")

func highlight(content: String, name: String) {
    let context = JSContext()
    context.evaluateScript(highlightJS)
}

class FileViewController: UIViewController {

    let viewModel = FileViewModel()
    let bag = SubscriptionBag()
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadContent()
        let text: Property<String?> = viewModel.content.map { content in
            if let content = content {
                return String(data: content, encoding: NSUTF8StringEncoding)
            } else {
                return nil
            }
        }
        text.bindTo(textView.wwText).addTo(bag)
    }
}
