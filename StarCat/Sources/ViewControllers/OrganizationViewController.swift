//
//  OrganizationViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/16.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import Kingfisher

class OrganizationViewController: RepoTableViewController {
    
    @IBOutlet weak var header: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var membersArea: UIView!
    
    let viewModel = UserViewModel()
    
    override func viewDidLoad() {
        let pagination = UserRepoPagination()
        self.pagination = pagination
        
        super.viewDidLoad()
        
        viewModel.login.bindTo { login in
            if login != "" {
                pagination.userName = login
                pagination.fetchAndReset().catch { print($0) }
            }
        }.addTo(bag)
        
        viewModel.user.bindTo { [weak self] _ in
            self?.tableView.layoutIfNeeded()
            self?.header.resizeHeightToMinimum()
        }.addTo(bag)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(OrganizationViewController.showActivity))
        
        viewModel.avatarURL.bindTo { [weak self] link in
            self?.avatarImageView.kf.setImage(with: link?.url)
        }.addTo(bag)
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
        membersArea.makeTappable().subscribe { [weak self] _ in
            self?.showMembers()
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
    
    private func showMembers() {
        navigationController?.push(storyboard: "UserTable", animated: true) { next in
            let userTableVC = next as! UserTableViewController
            let pagination = MembersPagination()
            pagination.organizationName = self.viewModel.login.value
            userTableVC.pagination = pagination
            userTableVC.title = "Members"
        }
    }
}
