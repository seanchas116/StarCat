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
import Kingfisher

class RepoViewController: UIViewController {
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var miscInfoLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var starsButton: RoundButton!
    @IBOutlet weak var viewCodeButton: RoundButton!
    @IBOutlet weak var markdownView: MarkdownView!
    
    let bag = SubscriptionBag()
    let viewModel = RepoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(RepoViewController.showActivity))
        
        viewModel.name.bindTo(wwTitle).addTo(bag)
        viewModel.name.bindTo(titleLabel.wwText).addTo(bag)
        viewModel.description.bindTo(descriptionLabel.wwText).addTo(bag)
        viewModel.avatarURL.bindTo { [weak self] url in
            self?.avatarImageView.kf.setImage(with: url)
        }.addTo(bag)
        viewModel.ownerName.bindTo(ownerLabel.wwText).addTo(bag)
        viewModel.homepage.map { $0?.stringWithoutScheme ?? ""}.bindTo(homepageLabel.wwText).addTo(bag)
        viewModel.homepage.map { $0 == nil }.bindTo(homepageLabel.wwHidden).addTo(bag)
        viewModel.starsCount.map { "★  \($0)" }.bindTo(starsButton.wwState(.normal).title).addTo(bag)
        viewModel.starred.bindTo(starsButton.wwSelected).addTo(bag)
        
        combine(viewModel.language, viewModel.pushedAt) { "\($0 ?? "")・\($1.formatForUI())" }
            .bindTo(miscInfoLabel.wwText).addTo(bag)
        
        viewModel.readme.bindTo(markdownView.html).addTo(bag)
        markdownView.header = header
        viewModel.fullName.bindTo { [weak self] name in
            self?.markdownView.repoFullName = name
        }.addTo(bag)
        
        ownerLabel.makeTappable().subscribe { [weak self] _ in
            self?.showOwner()
        }.addTo(bag)
        
        homepageLabel.makeTappable().subscribe { [unowned self] _ in
            WebViewPopup.open(self.viewModel.homepage.value!, on: self)
        }.addTo(bag)
        
        viewCodeButton.wwTapped.subscribe { [weak self] in
            self?.showFiles()
        }.addTo(bag)
        
        starsButton.wwTapped.subscribe { [weak self] in
            self?.toggleStar()
        }.addTo(bag)
        
        viewModel.fetchReadme()
        
        viewModel.repo.bindTo { [weak self] _ in
            self?.header.resizeHeightToMinimum()
        }.addTo(bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showOwner() {
        if let owner = viewModel.repo.value?.owner {
            navigationController?.push(userSummary: owner)
        }
    }
    
    private func showFiles() {
        if let fullName = viewModel.repo.value?.fullName {
            let file = File(type: .Dir, name: "Files", path: "")
            navigationController?.push(file: file, repo: fullName)
        }
    }
    
    func showActivity() {
        if let url = viewModel.githubURL.value {
            WebViewPopup.openActivity(url, on: self)
        }
    }
    
    func toggleStar() {
        viewModel.toggleStar().catch { print($0) }
    }
}
