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
            let pagination = UserRepoPagination()
            pagination.userName = userSummary.login
            self.pagination = pagination
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
        
        viewModel.avatarImage.bindTo(avatarImageView.wwImage).addTo(bag)
        viewModel.name.bindTo(nameLabel.wwText).addTo(bag)
        viewModel.login.bindTo(loginLabel.wwText).addTo(bag)
        
        viewModel.location.map { $0 ?? "" }.bindTo(locationLabel.wwText).addTo(bag)
        viewModel.location.map { $0 == nil }.bindTo(locationLabel.wwHidden).addTo(bag)
        viewModel.homepage.map { $0?.stringWithoutScheme ?? "" }.bindTo(homepageLabel.wwText).addTo(bag)
        viewModel.homepage.map { $0 == nil }.bindTo(locationLabel.wwHidden).addTo(bag)
        homepageLabel.makeTappable().subscribe { [unowned self] _ in
            if let url = self.viewModel.homepage.value {
                WebViewPopup.open(url, on: self)
            }
        }.addTo(bag)
        viewModel.login.bindTo(wwTitle).addTo(bag)
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
