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

class OrganizationViewController: UITableViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var homepageLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    
    var userSummary: UserSummary?
    let viewModel = UserViewModel()
    let disposeBag = DisposeBag()
    var paginator: TableViewPaginator<RepoViewModel>!
    var selectedRepoVM: RepoViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "RepoCell", bundle: nil), forCellReuseIdentifier: "RepoCell")
        
        viewModel.avatarImage.bindTo(avatarImageView.rx_image).addDisposableTo(disposeBag)
        viewModel.name.bindTo(nameLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.login.bindTo(loginLabel.rx_text).addDisposableTo(disposeBag)
        
        viewModel.location.map { $0 ?? "" }.bindTo(locationLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.location.map { $0 == nil }.bindTo(locationLabel.rx_hidden).addDisposableTo(disposeBag)
        viewModel.homepage.map { $0?.URLString ?? "" }.bindTo(homepageLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.homepage.map { $0 == nil }.bindTo(locationLabel.rx_hidden).addDisposableTo(disposeBag)
        homepageLabel.makeTappable().subscribeNext { [unowned self] _ in
            WebViewPopup.open(self.viewModel.homepage.value!, onViewController: self)
        }.addDisposableTo(disposeBag)
        
        if let summary = userSummary {
            viewModel.setSummary(summary)
            viewModel.load().then {
                self.tableView.layoutIfNeeded()
            }
            let pagination = UserRepoPagination(userName: summary.login)
            paginator = TableViewPaginator(
                tableView: tableView, refreshControl: refreshControl!,
                pagination: pagination
                ) { items in
                    items.bindTo(self.tableView.rx_itemsWithCellIdentifier("RepoCell")) { row, elem, cell in
                        let repoCell = cell as! RepoCell
                        repoCell.viewModel = elem
                    }
            }
        }
        
        paginator.whenSelected.subscribeNext { [unowned self] repoVM in
            self.selectedRepoVM = repoVM
            self.performSegueWithIdentifier("showRepo", sender: self)
        }.addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier {
            switch id {
            case "showRepo":
                if selectedRepoVM != nil {
                    let subVC = (segue.destinationViewController as! RepoViewController)
                    subVC.viewModel = selectedRepoVM
                }
            default:
                break
            }
        }
    }
}
