//
//  RepoViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/03.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import WebKit
import Wirework
import SwiftDate

class ReadmeView: UIView {
    var webView: WKWebView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override var bounds: CGRect {
        didSet {
            webView.frame = bounds
        }
    }
    
    private func setup() {
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: bounds, configuration: config)
        addSubview(webView)
    }
}

class RepoViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var miscInfoLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var stargazersButton: RoundButton!
    @IBOutlet weak var readmeLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var readmeView: ReadmeView!
    @IBOutlet weak var readmeHeightConstraint: NSLayoutConstraint!
    
    let bag = SubscriptionBag()
    let viewModel = RepoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("showActivity"))
        
        viewModel.name.bindTo(wwTitle).addTo(bag)
        viewModel.name.bindTo(titleLabel.wwText).addTo(bag)
        viewModel.description.bindTo(descriptionLabel.wwText).addTo(bag)
        viewModel.avatarImage.bindTo(avatarImageView.wwImage).addTo(bag)
        viewModel.ownerName.bindTo(ownerLabel.wwText).addTo(bag)
        viewModel.homepage.map { $0?.stringWithoutScheme ?? ""}.bindTo(homepageLabel.wwText).addTo(bag)
        viewModel.homepage.map { $0 == nil }.bindTo(homepageLabel.wwHidden).addTo(bag)
        viewModel.starsCount.map { String($0) }.bindTo(stargazersButton.wwState(.Normal).title).addTo(bag)
        
        combine(viewModel.language, viewModel.pushedAt) { "\($0 ?? "")・\($1.formatForUI(withAgo: true))" }
            .bindTo(miscInfoLabel.wwText).addTo(bag)
        
        readmeHeightConstraint.constant = 0
        
        viewModel.readme
            .map(wrapReadme)
            .bindTo { [unowned self] html in
                self.readmeView.webView.loadHTMLString(html, baseURL: nil)
            }.addTo(bag)
        readmeView.webView.navigationDelegate = self
        
        ownerLabel.makeTappable().subscribe { [weak self] _ in
            self?.showOwner()
        }.addTo(bag)
        
        homepageLabel.makeTappable().subscribe { [unowned self] _ in
            WebViewPopup.open(self.viewModel.homepage.value!, on: self)
        }.addTo(bag)
        
        viewModel.fetchReadme()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showOwner() {
        if let owner = viewModel.repo.value?.owner {
            if let type = owner.type {
                if type == .Organization {
                    self.navigationController?.pushStoryboard("Organization", animated: true) { next in
                        (next as! OrganizationViewController).userSummary = owner
                    }
                    return
                }
            }
            self.navigationController?.pushStoryboard("User", animated: true) { next in
                (next as! UserViewController).userSummary = owner
            }
        }
        
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.height") { (result, error) in
            if error == nil {
                if let height = result! as? Double {
                    self.readmeHeightConstraint.constant = CGFloat(height)
                }
            }
        }
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let URL = navigationAction.request.URL {
            if URL.absoluteString != "about:blank" {
                if let link = Link(URL: URL) {
                    WebViewPopup.open(link, on: self)
                    decisionHandler(.Cancel)
                }
                return
            }
        }
        decisionHandler(.Allow)
    }
    
    func showActivity() {
        if let url = viewModel.githubURL.value {
            WebViewPopup.openActivity(url, on: self)
        }
    }
}

private let baseReadmeCSS = getBundleFile("github-markdown", ofType: "css")
private let customReadmeCSS = getBundleFile("github-markdown-custom", ofType: "css")

private func getBundleFile(fileName: String, ofType: String) -> String {
    if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: ofType) {
        return (try? String(contentsOfFile: path, encoding: NSUTF8StringEncoding)) ?? ""
    }
    return ""
}

private func wrapReadme(htmlBody: String) -> String {
    return "<html><head><meta name='viewport' content='initial-scale=1, maximum-scale=1'><style>\(baseReadmeCSS)\(customReadmeCSS)</style></head><body>\(htmlBody)</body></html>"
}

private func renderReadme(html: String) -> NSAttributedString? {
    let fullHTML = "<html><head><style>\(baseReadmeCSS)\(customReadmeCSS)</style></head><body>\(html)</body></html>"
    return try? NSAttributedString(
        data: fullHTML.dataUsingEncoding(NSUTF8StringEncoding)!,
        options: [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSNumber(unsignedLong: NSUTF8StringEncoding)
        ],
        documentAttributes: nil
    )
}
