//
//  UITableViewPaginator.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/13.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TableViewPaginator<T> {
    let tableView: UITableView
    let refreshControl: UIRefreshControl
    let pagination: Pagination<T>
    var initialized = false
    let loading = Variable(false)
    let loadingMore = Variable(false)
    let disposeBag = DisposeBag()
    var whenSelected: Observable<T?>!
    
    init(tableView: UITableView, refreshControl: UIRefreshControl, pagination: Pagination<T>, bind: (Variable<[T]>) -> Disposable) {
        self.tableView = tableView
        self.refreshControl = refreshControl
        self.pagination = pagination
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        whenSelected = tableView.rx_itemSelected.map { [weak self] index -> T? in
            if let this = self {
                return this.pagination.items.value[index.row]
            }
            return nil
        }
        
        bind(pagination.items).addDisposableTo(disposeBag)
        
        refreshControl.rx_controlEvents(UIControlEvents.ValueChanged).subscribeNext { _ in
            self.fetch()
        }.addDisposableTo(disposeBag)
        
        loading.subscribeNext { [weak self] loading in
            if loading {
                self?.refreshControl.beginRefreshing()
            } else {
                self?.refreshControl.endRefreshing()
            }
        }.addDisposableTo(disposeBag)
        
        tableView.rx_contentOffset.subscribeNext { [weak self] _ in
            self?.didScroll()
        }.addDisposableTo(disposeBag)
        
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