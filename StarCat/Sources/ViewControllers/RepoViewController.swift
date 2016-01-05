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

class RepoViewController: UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var miscInfoLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var stargazersButton: RoundButton!
    @IBOutlet weak var readmeView: UITextView!
    
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
        
        combineLatest(viewModel.language, viewModel.pushedAtText) { "\($0 ?? "")・\($1)" }
            .bindTo(miscInfoLabel.rx_text).addDisposableTo(disposeBag)
        
        viewModel.readme
            .observeOn(ConcurrentDispatchQueueScheduler(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)))
            .map(renderReadme)
            .observeOn(MainScheduler.sharedInstance)
            .subscribeNext { [weak self] attributedText in
                self?.readmeView.attributedText = attributedText
                self?.readmeView.layoutIfNeeded()
            }
            .addDisposableTo(disposeBag)
        
        viewModel.fetchReadme()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
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
