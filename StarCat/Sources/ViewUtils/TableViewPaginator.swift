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
    let refreshControl: UIRefreshControl
    let pagination: Pagination<T>
    var initialized = false
    let loading = Variable(false)
    let loadingMore = Variable(false)
    let bag = SubscriptionBag()
    var whenSelected: Signal<T?>!
    
    init(tableView: UITableView, refreshControl: UIRefreshControl, pagination: Pagination<T>, bind: (Variable<[T]>) -> Subscription) {
        self.tableView = tableView
        self.refreshControl = refreshControl
        self.pagination = pagination
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        whenSelected = tableView.wwItemSelected.map { [weak self] index -> T? in
            if let this = self {
                return this.pagination.items.value[index.row]
            }
            return nil
        }
        
        bind(pagination.items).addTo(bag)
        
        refreshControl.wwControlEvent(UIControlEvents.ValueChanged).subscribe { _ in
            self.fetch()
        }.addTo(bag)
        
        loading.bindTo(refreshControl.wwRefreshing).addTo(bag)
        
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
        if let indexBottom = tableView.indexPathForRowAtPoint(CGPointMake(0, offset + height)) {
            let itemCount = pagination.items.value.count
            if itemCount > 0 && itemCount - indexBottom.row > 8 {
                return
            }
        }
        fetchMore()
    }
    
    func refresh() {
        loading.value = true
        pagination.refresh().always {
            self.loading.value = false
        }
    }
    
    func fetch() {
        loading.value = true
        pagination.fetchAndReset().always {
            self.loading.value = false
        }
    }
    
    func fetchMore() {
        loadingMore.value = true
        pagination.fetchMore().always {
            self.loadingMore.value = false
        }
    }
}