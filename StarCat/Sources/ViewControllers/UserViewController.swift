//
//  UserViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/10.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import RxSwift

class UserViewController: RepoTableViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var followButton: RoundButton!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    var userSummary: UserSummary? {
        didSet {
            let pagination = UserRepoPagination()
            pagination.userName = userSummary!.login
            self.pagination = pagination
            viewModel.setSummary(userSummary!)
            viewModel.load().then {
                self.tableView.layoutIfNeeded()
            }
        }
    }
    let viewModel = UserViewModel()
    
    override func viewDidLoad() {
        if userSummary == nil {
            let pagination = UserRepoPagination()
            self.pagination = pagination
            viewModel.loadCurrentUser().then { () -> Void in
                pagination.userName = self.viewModel.login.value
                self.paginator.refresh()
                self.tableView.layoutIfNeeded()
            }
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(image: UIImage(named: "navigation-config"), style: .Plain, target: self, action: Selector("showProfileMenu")),
                UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("showActivity"))
            ]
            navigationItem.title = "Profile"
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("showActivity"))
            navigationItem.title = userSummary?.login
        }
        
        super.viewDidLoad()
        
        viewModel.avatarImage.bindTo(avatarImageView.rx_image).addDisposableTo(disposeBag)
        viewModel.name.bindTo(nameLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.login.bindTo(loginLabel.rx_text).addDisposableTo(disposeBag)
        
        viewModel.location.map { $0 ?? "" }.bindTo(locationLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.location.map { $0 == nil }.bindTo(locationLabel.rx_hidden).addDisposableTo(disposeBag)
        viewModel.homepage.map { $0?.stringWithoutScheme ?? "" }.bindTo(homepageLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.homepage.map { $0 == nil }.bindTo(locationLabel.rx_hidden).addDisposableTo(disposeBag)
        homepageLabel.makeTappable().subscribeNext { [unowned self] _ in
            if let link = self.viewModel.homepage.value {
                WebViewPopup.open(link, on: self)
            }
        }.addDisposableTo(disposeBag)
        
        viewModel.followersCount.map { String($0) }.bindTo(followersLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.followingCount.map { String($0) }.bindTo(followingLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.starsCount.map { String($0) }.bindTo(starsLabel.rx_text).addDisposableTo(disposeBag)
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
    
    func showProfileMenu() {
        presentStoryboard("Settings", animated: true)
    }
}
