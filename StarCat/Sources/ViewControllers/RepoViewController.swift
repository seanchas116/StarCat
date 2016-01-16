//
//  RepoViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/03.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftDate

class RepoViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var miscInfoLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var stargazersButton: RoundButton!
    @IBOutlet weak var readmeView: ReadmeTextView!
    @IBOutlet weak var readmeLoadingIndicator: UIActivityIndicatorView!
    
    let disposeBag = DisposeBag()
    var viewModel: RepoViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        viewModel.readme
            .observeOn(ConcurrentDispatchQueueScheduler(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)))
            .map(renderReadme)
            .observeOn(MainScheduler.sharedInstance)
            .subscribeNext { [weak self] attributedText in
                self?.readmeView.loadContent(attributedText).then { () -> Void in
                    self?.readmeLoadingIndicator.stopAnimating()
                }
                self?.readmeView.layoutIfNeeded()
            }
            .addDisposableTo(disposeBag)
        
        readmeView.delegate = self
        
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

    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        WebViewPopup.open(URL, onViewController: self)
        return false
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
