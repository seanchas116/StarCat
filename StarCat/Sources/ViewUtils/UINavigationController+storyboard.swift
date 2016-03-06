//
//  UINavigationController+.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/16.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    func pushStoryboard(name: String, animated: Bool, config: (UIViewController) -> Void) {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let next = storyboard.instantiateInitialViewController() {
            config(next)
            pushViewController(next, animated: animated)
        }
    }
    
    func pushRepo(repo: Repo) {
        pushStoryboard("Repo", animated: true) { next in
            (next as! RepoViewController).viewModel.repo.value = repo
        }
    }
    
    func pushUser(userSummary: UserSummary) {
        if userSummary.type == .Organization {
            pushStoryboard("Organization", animated: true) { next in
                let orgVC = next as! OrganizationViewController
                orgVC.viewModel.summary.value = userSummary
                orgVC.viewModel.load()
            }
        } else {
            pushStoryboard("User", animated: true) { next in
                let userVC = next as! UserViewController
                userVC.mode = .User
                userVC.viewModel.summary.value = userSummary
                userVC.viewModel.load()
            }
        }
    }
    
    func pushUser(user: User) {
        if user.type == .Organization {
            pushStoryboard("Organization", animated: true) { next in
                (next as! OrganizationViewController).viewModel.user.value = user
            }
        } else {
            pushStoryboard("User", animated: true) { next in
                let userVC = next as! UserViewController
                userVC.mode = .User
                userVC.viewModel.user.value = user
            }
        }
    }
    
    func pushDirectory(path: String, repo: String) {
        pushStoryboard("FileTable", animated: true) { next in
            let fileTableViewController = next as! FileTableViewController
            fileTableViewController.viewModel.repoName.value = repo
            fileTableViewController.viewModel.dirPath.value = path
        }
    }
}