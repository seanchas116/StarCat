//
//  RepoTableViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/17.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import Wirework

class RepoTableViewController: UITableViewController {
    
    var pagination: Pagination<Repo>!
    var paginator: TableViewPaginator<Repo>!
    let bag = SubscriptionBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "RepoCell", bundle: nil), forCellReuseIdentifier: "RepoCell")
        
        paginator = TableViewPaginator<Repo>(
            tableViewController: self,
            pagination: pagination,
            cellIdentifier: "RepoCell"
        ) { [weak self] row, repo, cell in
            let repoCell = cell as! RepoCell
            repoCell.viewModel.repo.value = repo
            repoCell.onActorTapped = { actor in
                self?.navigationController?.pushStoryboard("User", animated: true) { next in
                    (next as! UserViewController).userSummary = actor
                }
            }
        }
        
        paginator.whenSelected.subscribe { [unowned self] repo in
            if let repo = repo {
                self.navigationController?.pushRepo(repo)
            }
        }.addTo(bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
