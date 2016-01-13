//
//  NewsTableViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/01.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsTableViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    let viewModel = NewsTabViewModel()
    var selectedRepoViewModel: RepoViewModel?
    var showingActor: UserSummary?
    let appeared = Variable(false)
    var paginator: TableViewPaginator<RepoViewModel>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        NSNotificationCenter.defaultCenter().rx_notification(UIApplicationDidBecomeActiveNotification)
            .subscribeNext { [weak self] _ in
                print("activated")
                self?.paginator.refresh()
            }
            .addDisposableTo(disposeBag)
        
        AppViewModel.instance.tabViewModel.selectedIndex.subscribeNext { index in
            print(index)
            if index == 0 && self.appeared.value {
                print("scrolling")
                self.scrollToTop()
            }
        }.addDisposableTo(disposeBag)
        
        paginator.refresh()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        paginator.refresh()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        appeared.value = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        appeared.value = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupTableView() {
        refreshControl = UIRefreshControl()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "RepoCell", bundle: nil), forCellReuseIdentifier: "RepoCell")
        
        self.paginator = TableViewPaginator(
            tableView: tableView, refreshControl: refreshControl!,
            collection: viewModel.newsCollection) { items in
            items.bindTo(self.tableView.rx_itemsWithCellIdentifier("RepoCell")) { [unowned self] row, elem, cell in
                let repoCell = cell as! RepoCell
                repoCell.viewModel = elem
                repoCell.onActorTapped = { [unowned self] actor in
                    self.showingActor = actor
                    self.performSegueWithIdentifier("showActor", sender: self)
                }
            }
        }
        
        tableView.rx_itemSelected.subscribeNext { [weak self] path in
            self?.tableSelected(path)
        }.addDisposableTo(disposeBag)
    }
    
    private func tableSelected(path: NSIndexPath) {
        selectedRepoViewModel = viewModel.newsCollection.items.value[path.row]
        performSegueWithIdentifier("showRepo", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let id = segue.identifier {
            switch id {
            case "showRepo":
                if selectedRepoViewModel != nil {
                    let subVC = (segue.destinationViewController as! RepoViewController)
                    subVC.viewModel = selectedRepoViewModel
                }
            case "showActor":
                if showingActor != nil {
                    let subVC = (segue.destinationViewController as! UserViewController)
                    subVC.userSummary = showingActor
                }
            default:
                break
            }
        }
    }
}
