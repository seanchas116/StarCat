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
    let loading = Variable(false)
    let loadingMore = Variable(false)
    let appeared = Variable(false)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        setupTableView()
        
        NSNotificationCenter.defaultCenter().rx_notification(UIApplicationDidBecomeActiveNotification)
            .subscribeNext { [weak self] _ in
                print("activated")
                self?.refresh()
            }
            .addDisposableTo(disposeBag)
        
        AppViewModel.instance.tabViewModel.selectedIndex.subscribeNext { index in
            print(index)
            if index == 0 && self.appeared.value {
                print("scrolling")
                self.scrollToTop()
            }
        }.addDisposableTo(disposeBag)
        
        refresh()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
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
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.rx_controlEvents(UIControlEvents.ValueChanged).subscribeNext { _ in
            self.fetch()
        }.addDisposableTo(disposeBag)
        loading.subscribeNext { [weak self] loading in
            if loading {
                self?.refreshControl?.beginRefreshing()
            } else {
                self?.refreshControl?.endRefreshing()
            }
        }.addDisposableTo(disposeBag)
    }
    
    private func setupTableView() {
        tableView.dataSource = nil
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "RepoCell", bundle: nil), forCellReuseIdentifier: "RepoCell")
        
        viewModel.repos.bindTo(tableView.rx_itemsWithCellIdentifier("RepoCell")) { row, elem, cell in
            (cell as RepoCell).viewModel = elem
        }.addDisposableTo(disposeBag)
        
        tableView.rx_itemSelected.subscribeNext { [weak self] path in
            self?.tableSelected(path)
        }.addDisposableTo(disposeBag)
    }
    
    func refresh() {
        loading.value = true
        viewModel.refreshEvents().always { [weak self] in
            self?.loading.value = false
        }
    }
    
    func fetch() {
        loading.value = true
        viewModel.fetchEvents().always { [weak self] in
            self?.loading.value = false
        }
    }
    
    private func tableSelected(path: NSIndexPath) {
        selectedRepoViewModel = viewModel.repos.value[path.row]
        performSegueWithIdentifier("showRepo", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showRepo" && selectedRepoViewModel != nil) {
            let subVC = (segue.destinationViewController as! RepoViewController)
            subVC.viewModel = selectedRepoViewModel
        }
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if loading.value || loadingMore.value {
            return
        }
        let offset = scrollView.contentOffset.y
        let height = scrollView.frame.size.height
        let distanceFromBottom = scrollView.contentSize.height - offset
        if distanceFromBottom < height {
            loadingMore.value = true
            viewModel.fetchMoreEvents().always {
                self.loadingMore.value = false
            }
        }
    }
    
    private func scrollToTop() {
        if numberOfSectionsInTableView(tableView) > 0 {
            let top = NSIndexPath(forRow: NSNotFound, inSection: 0)
            tableView.scrollToRowAtIndexPath(top, atScrollPosition: .Top, animated: true)
        }
    }
}
