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
    
    let viewModel = NewsViewModel()
    let appeared = Variable(false)
    var paginator: TableViewPaginator<News>!
    let bag = SubscriptionBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "RepoCell", bundle: nil), forCellReuseIdentifier: "RepoCell")
        
        paginator = TableViewPaginator<News>(
            tableViewController: self,
            pagination: viewModel.pagination,
            cellIdentifier: "RepoCell"
            ) { [weak self] row, news, cell in
                let repoCell = cell as! RepoCell
                repoCell.viewModel.repo.value = news.repo
                repoCell.viewModel.event.value = news.event
                repoCell.onActorTapped = { actor in
                    self?.navigationController?.push(userSummary: actor)
                }
        }
        
        paginator.whenSelected.subscribe { [unowned self] news in
            if let news = news {
                self.navigationController?.push(repo: news.repo)
            }
        }.addTo(bag)
        paginator.loading.value = true
        
        NotificationCenter.default
            .wwNotification(NSNotification.Name.UIApplicationDidBecomeActive)
            .subscribe { [weak self] _ in
                print("activated")
                self?.paginator.refresh()
            }
        .addTo(bag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appeared.value = true
        if !Authentication.isLoggedIn {
            LoginButtonViewController.show(on: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        paginator.refresh()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appeared.value = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
