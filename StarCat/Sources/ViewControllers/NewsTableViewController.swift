//
//  NewsTableViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/01.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import Wirework

class NewsTableViewController: UITableViewController {
    
    let viewModel = NewsTabViewModel()
    let appeared = Variable(false)
    var paginator: TableViewPaginator<News>!
    let bag = SubscriptionBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "RepoCell", bundle: nil), forCellReuseIdentifier: "RepoCell")
        
        paginator = TableViewPaginator<News>(
            tableViewController: self,
            pagination: viewModel.newsPagination,
            cellIdentifier: "RepoCell"
            ) { [weak self] row, news, cell in
                let repoCell = cell as! RepoCell
                repoCell.viewModel.repo.value = news.repo
                repoCell.viewModel.event.value = news.event
                repoCell.onActorTapped = { actor in
                    self?.navigationController?.pushStoryboard("User", animated: true) { next in
                        (next as! UserViewController).userSummary = actor
                    }
                }
        }
        
        paginator.whenSelected.subscribe { [unowned self] news in
            if let news = news {
                self.navigationController?.pushRepo(news.repo)
            }
        }.addTo(bag)
        paginator.loading.value = true
        
        NSNotificationCenter.defaultCenter()
            .wwNotification(UIApplicationDidBecomeActiveNotification)
            .subscribe { [weak self] _ in
                print("activated")
                self?.paginator.refresh()
            }
        .addTo(bag)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        appeared.value = true
        if !Authentication.isLoggedIn {
            LoginButtonViewController.showOn(self)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        paginator.refresh()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        appeared.value = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
