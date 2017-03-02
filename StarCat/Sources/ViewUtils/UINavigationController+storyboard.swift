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
    func push(storyboard name: String, animated: Bool, config: (UIViewController) -> Void) {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let next = storyboard.instantiateInitialViewController() {
            config(next)
            pushViewController(next, animated: animated)
        }
    }
    
    func push(repo: Repo) {
        push(storyboard: "Repo", animated: true) { next in
            (next as! RepoViewController).viewModel.repo.value = repo
        }
    }
    
    func push(userSummary: UserSummary) {
        if userSummary.type == .organization {
            push(storyboard: "Organization", animated: true) { next in
                let orgVC = next as! OrganizationViewController
                orgVC.viewModel.summary.value = userSummary
                orgVC.viewModel.load().catch { print($0) }
            }
        } else {
            push(storyboard: "User", animated: true) { next in
                let userVC = next as! UserViewController
                userVC.mode = .User
                userVC.viewModel.summary.value = userSummary
                userVC.viewModel.load().catch { print($0) }
            }
        }
    }
    
    func push(user: User) {
        if user.type == .organization {
            push(storyboard: "Organization", animated: true) { next in
                (next as! OrganizationViewController).viewModel.user.value = user
            }
        } else {
            push(storyboard: "User", animated: true) { next in
                let userVC = next as! UserViewController
                userVC.mode = .User
                userVC.viewModel.user.value = user
            }
        }
    }
    
    func push(file: File, repo: String) {
        if file.type == .Dir {
            push(storyboard: "FileTable", animated: true) { next in
                let fileTableViewController = next as! FileTableViewController
                fileTableViewController.viewModel.repoName.value = repo
                fileTableViewController.viewModel.file.value = file
            }
        } else {
            push(storyboard: "File", animated: true) { next in
                let fileViewController = next as! FileViewController
                fileViewController.viewModel.repoName.value = repo
                fileViewController.viewModel.file.value = file
            }
        }
    }
}
