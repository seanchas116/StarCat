//
//  UITableViewPaginator.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/13.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import UIKit
import Wirework
import WireworkUIKit

class TableViewPaginator<T> {
    let tableView: UITableView
    let refreshControl = UIRefreshControl()
    let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let pagination: Pagination<T>
    var initialized = false
    let loading = Variable(false)
    let loadingMore = Variable(false)
    let bag = SubscriptionBag()
    var whenSelected: Signal<T?>!
    
    init(tableViewController: UITableViewController, pagination: Pagination<T>, cellIdentifier: String, bind: @escaping (Int, T, UITableViewCell) -> Void) {
        tableView = tableViewController.tableView!
        
        tableViewController.refreshControl = refreshControl
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        tableView.tableFooterView = loadingIndicator
        
        self.pagination = pagination
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        whenSelected = tableView.wwItemSelected.map { [weak self] index -> T? in
            if let this = self {
                return this.pagination.items.value[index.row]
            }
            return nil
        }
        
        pagination.items.bindTo(tableView.wwRows(cellIdentifier, bind: bind)).addTo(bag)
        
        refreshControl.wwControlEvent(UIControlEvents.valueChanged).subscribe { _ in
            self.fetch()
        }.addTo(bag)
        
        loading.bindTo(refreshControl.wwRefreshing).addTo(bag)
        loadingMore.bindTo(loadingIndicator.wwAnimating).addTo(bag)
        
        tableView.wwDidScroll.subscribe { [weak self] _ in
            self?.didScroll()
        }.addTo(bag)
        
        initialized = true
    }
    
    private func didScroll() {
        if !initialized || loading.value || loadingMore.value {
            return
        }
        let offset = tableView.contentOffset.y
        let height = tableView.frame.size.height
        if let indexBottom = tableView.indexPathForRow(at: CGPoint(x: 0, y: offset + height)) {
            let itemCount = pagination.items.value.count
            if itemCount > 0 && itemCount - indexBottom.row > 8 {
                return
            }
        }
        fetchMore()
    }
    
    func refresh() {
        loading.value = true
        pagination.refresh().catch { print($0) }.always {
            self.loading.value = false
        }
    }
    
    func fetch() {
        loading.value = true
        pagination.fetchAndReset().catch { print($0) }.always {
            self.loading.value = false
        }
    }
    
    func fetchMore() {
        if !pagination.canFetchMore {
            return
        }
        loadingMore.value = true
        pagination.fetchMore().catch { print($0) }.always {
            self.loadingMore.value = false
        }
    }
}
