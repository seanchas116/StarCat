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

class FileViewController: UIViewController, UIScrollViewDelegate {

    let viewModel = FileViewModel()
    let bag = SubscriptionBag()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var codeView: CodeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        loadingIndicator.startAnimating()
        
        let name = viewModel.name.value
        viewModel.loadContent().then { content in
            return String(data: content, encoding: String.Encoding.utf8) ?? "Binary File"
        }.then { text in
            return self.codeView.loadContent(text, name: name)
        }.then {
            self.loadingIndicator.stopAnimating()
        }.catch { print($0) }
        viewModel.name.bindTo(wwTitle).addTo(bag)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return codeView
    }
}
