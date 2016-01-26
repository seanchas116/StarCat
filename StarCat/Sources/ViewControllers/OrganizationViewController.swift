//
//  OrganizationViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/16.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OrganizationViewController: RepoTableViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    
    var userSummary: UserSummary! {
        didSet {
            pagination = UserRepoPagination(userName: userSummary.login)
            viewModel.setSummary(userSummary)
            viewModel.load().then {
                self.tableView.layoutIfNeeded()
            }
        }
    }
    let viewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("showActivity"))
        
        viewModel.avatarImage.bindTo(avatarImageView.rx_image).addDisposableTo(disposeBag)
        viewModel.name.bindTo(nameLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.login.bindTo(loginLabel.rx_text).addDisposableTo(disposeBag)
        
        viewModel.location.map { $0 ?? "" }.bindTo(locationLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.location.map { $0 == nil }.bindTo(locationLabel.rx_hidden).addDisposableTo(disposeBag)
        viewModel.homepage.map { $0?.stringWithoutScheme ?? "" }.bindTo(homepageLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.homepage.map { $0 == nil }.bindTo(locationLabel.rx_hidden).addDisposableTo(disposeBag)
        homepageLabel.makeTappable().subscribeNext { [unowned self] _ in
            if let url = self.viewModel.homepage.value {
                WebViewPopup.open(url, on: self)
            }
        }.addDisposableTo(disposeBag)
        
        viewModel.login.subscribeNext { [weak self] name in
            self?.title = name
        }.addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showActivity() {
        if let url = viewModel.githubURL.value {
            WebViewPopup.openActivity(url, on: self)
        }
    }
}
