//
//  RepoTableViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/17.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import RxSwift

class RepoTableViewController: UITableViewController {
    
    var pagination: Pagination<RepoViewModel>!
    var paginator: TableViewPaginator<RepoViewModel>!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "RepoCell", bundle: nil), forCellReuseIdentifier: "RepoCell")
        
        paginator = TableViewPaginator(
            tableView: tableView, refreshControl: refreshControl!,
            pagination: pagination) { items in
                items.bindTo(self.tableView.rx_itemsWithCellIdentifier("RepoCell")) { [unowned self] row, elem, cell in
                    let repoCell = cell as! RepoCell
                    repoCell.viewModel = elem
                    repoCell.onActorTapped = { [unowned self] actor in
                        self.navigationController?.pushStoryboard("User", animated: true) { next in
                            (next as! UserViewController).userSummary = actor
                        }
                    }
                }
        }
        paginator.whenSelected.subscribeNext { [unowned self] repoVM in
            self.navigationController?.pushStoryboard("Repo", animated: true) { next in
                (next as! RepoViewController).viewModel = repoVM
            }
        }.addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
