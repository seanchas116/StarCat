//
//  UserViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/10.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit

class UserViewController: RepoTableViewController {
    enum Mode {
        case User
        case Profile
    }
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var followButton: RoundButton!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersArea: UIView!
    @IBOutlet weak var starsArea: UIView!
    @IBOutlet weak var followingArea: UIView!
    
    var mode = Mode.Profile
    
    let viewModel = UserViewModel()
    
    override func viewDidLoad() {
        let pagination = UserRepoPagination()
        self.pagination = pagination
        super.viewDidLoad()
        
        viewModel.login.bindTo { login in
            if login != "" {
                pagination.userName = login
                pagination.fetchAndReset()
            }
        }.addTo(bag)
        
        viewModel.user.bindTo { [weak self] _ in
            self?.tableView.layoutIfNeeded()
        }.addTo(bag)
        
        if mode == .Profile {
            viewModel.loadCurrentUser()
            
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(image: UIImage(named: "navigation-config"), style: .Plain, target: self, action: Selector("showProfileMenu")),
                UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("showActivity"))
            ]
            navigationItem.title = "Profile"
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: Selector("showActivity"))
            viewModel.login.bindTo(navigationItem.wwTitle).addTo(bag)
        }
        
        
        viewModel.avatarImage.bindTo(avatarImageView.wwImage).addTo(bag)
        viewModel.name.bindTo(nameLabel.wwText).addTo(bag)
        viewModel.login.bindTo(loginLabel.wwText).addTo(bag)
        
        viewModel.location.map { $0 ?? "" }.bindTo(locationLabel.wwText).addTo(bag)
        viewModel.location.map { $0 == nil }.bindTo(locationLabel.wwHidden).addTo(bag)
        viewModel.homepage.map { $0?.stringWithoutScheme ?? "" }.bindTo(homepageLabel.wwText).addTo(bag)
        viewModel.homepage.map { $0 == nil }.bindTo(locationLabel.wwHidden).addTo(bag)
        
        homepageLabel.makeTappable().subscribe { [unowned self] _ in
            if let link = self.viewModel.homepage.value {
                WebViewPopup.open(link, on: self)
            }
        }.addTo(bag)
        
        viewModel.followersCount.map { String($0) }.bindTo(followersLabel.wwText).addTo(bag)
        viewModel.followingCount.map { String($0) }.bindTo(followingLabel.wwText).addTo(bag)
        viewModel.starsCount.map { String($0) }.bindTo(starsLabel.wwText).addTo(bag)
        
        followersArea.makeTappable().subscribe { [weak self] _ in
            self?.showFollowers()
        }.addTo(bag)
        followingArea.makeTappable().subscribe { [weak self] _ in
            self?.showFollowing()
        }.addTo(bag)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if mode == .Profile && !Authentication.isLoggedIn {
            LoginButtonViewController.showOn(self)
        }
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
    
    func showFollowers() {
        navigationController?.pushStoryboard("UserTable", animated: true) { next in
            let userTableVC = next as! UserTableViewController
            let pagination = FollowersPagination()
            pagination.userName = self.viewModel.login.value
            userTableVC.pagination = pagination
            userTableVC.title = "Followers"
        }
    }
    
    func showFollowing() {
        navigationController?.pushStoryboard("UserTable", animated: true) { next in
            let userTableVC = next as! UserTableViewController
            let pagination = FollowingPagination()
            pagination.userName = self.viewModel.login.value
            userTableVC.pagination = pagination
            userTableVC.title = "Following"
        }
    }
}
