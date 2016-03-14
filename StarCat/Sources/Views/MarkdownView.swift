//
//  MarkdownView.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/03/13.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import WebKit
import PromiseKit
import Wirework

private let baseReadmeCSS = getBundleFile("github-markdown", ofType: "css")
private let customReadmeCSS = getBundleFile("github-markdown-custom", ofType: "css")

private func wrapReadme(htmlBody: String) -> String {
    return "<html><head><meta name='viewport' content='initial-scale=1, maximum-scale=1'><style>\(baseReadmeCSS)\(customReadmeCSS)</style></head><body style=' visibility: hidden;'><div id='header-padding'></div>\(htmlBody)</body></html>"
}

class MarkdownView: UIView, WKNavigationDelegate {
    var webView: WKWebView!
    var viewController: UIViewController?
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
    
    let html = Variable<String?>(nil)
    let loading = Variable(true)
    let bag = SubscriptionBag()
    
    var header: UIView? {
        willSet {
            if let header = header {
                header.removeFromSuperview()
            }
        }
        didSet {
            if let header = header {
                webView.scrollView.addSubview(header)
            }
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: bounds, configuration: config)
        addSubview(webView)
        webView.navigationDelegate = self
        webView.scrollView.addSubview(loadingIndicator)
        
        html.bindTo { [weak self] html in
            self?.loading.value = true
            if let html = html {
                self?.webView.loadHTMLString(wrapReadme(html), baseURL: nil)
            }
        }.addTo(bag)
        loading.bindTo(loadingIndicator.wwAnimating).addTo(bag)
        loading.map { !$0 }.bindTo(loadingIndicator.wwHidden).addTo(bag)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        loading.value = false
        setHeaderPaddingHeight()
        showContent()
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let URL = navigationAction.request.URL {
            if URL.absoluteString != "about:blank" {
                if let link = Link(URL: URL) {
                    if let viewController = viewController {
                        WebViewPopup.open(link, on: viewController)
                    }
                    decisionHandler(.Cancel)
                }
                return
            }
        }
        decisionHandler(.Allow)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        webView.frame = bounds
        var headerHeight = CGFloat(0)
        if let header = header {
            headerHeight = header.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
            header.frame = CGRect(origin: CGPoint.zero, size: CGSizeMake(frame.width, headerHeight))
        }
        setHeaderPaddingHeight()
        loadingIndicator.center = CGPointMake(frame.width * 0.5, headerHeight + 16 + loadingIndicator.bounds.height * 0.5)
    }
    
    private func showContent() {
        webView.evaluateJavaScript("document.body.style.visibility = 'visible'")  { res, err in
            if let err = err {
                print(err)
            }
        }
    }
    
    private func setHeaderPaddingHeight() {
        let height = header?.bounds.height ?? 0
        webView.evaluateJavaScript("var padding = document.getElementById('header-padding'); if (padding) { padding.style.height = '\(height)px'; }") { res, err in
            if let err = err {
                print(err)
            }
        }
    }
}
