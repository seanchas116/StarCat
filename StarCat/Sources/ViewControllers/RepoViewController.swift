//
//  RepoViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/03.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
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
    
    let disposeBag = DisposeBag()
    var viewModel: RepoViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("showActivity"))
        
        print(viewModel)
        
        viewModel.name.subscribeNext { [weak self] name in
            self?.title = name
        }.addDisposableTo(disposeBag)
        viewModel.name.bindTo(titleLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.description.bindTo(descriptionLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.avatarImage.bindTo(avatarImageView.rx_image).addDisposableTo(disposeBag)
        viewModel.ownerName.bindTo(ownerLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.homepage.map { $0?.absoluteString ?? ""}.bindTo(homepageLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.homepage.map { $0 == nil }.bindTo(homepageLabel.rx_hidden).addDisposableTo(disposeBag)
        viewModel.starsCount.subscribeNext { [weak self] count in
            self?.stargazersButton.setTitle(String(count), forState: .Normal)
        }.addDisposableTo(disposeBag)
        
        combineLatest(viewModel.language, viewModel.pushedAt) { "\($0 ?? "")・\($1.formatForUI(withAgo: true))" }
            .bindTo(miscInfoLabel.rx_text).addDisposableTo(disposeBag)
        
        readmeHeightConstraint.constant = 0
        
        viewModel.readme
            .map(wrapReadme)
            .subscribeNext { [unowned self] html in
                self.readmeView.webView.loadHTMLString(html, baseURL: nil)
            }.addDisposableTo(disposeBag)
        readmeView.webView.navigationDelegate = self
        
        ownerLabel.makeTappable().subscribeNext { [weak self] _ in
            self?.showOwner()
        }.addDisposableTo(disposeBag)
        
        homepageLabel.makeTappable().subscribeNext { [unowned self] _ in
            WebViewPopup.open(self.viewModel.homepage.value!, onViewController: self)
        }.addDisposableTo(disposeBag)
        
        viewModel.fetchReadme()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showOwner() {
        let owner = viewModel.repo.owner
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
                WebViewPopup.open(URL, onViewController: self)
                decisionHandler(.Cancel)
                return
            }
        }
        decisionHandler(.Allow)
    }
    
    func showActivity() {
        if let url = viewModel.githubURL.value {
            let activity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            presentViewController(activity, animated: true, completion: nil)
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
