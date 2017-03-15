//
//  Paginator.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/11.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import Wirework
import PromiseKit
import SwiftDate

class Pagination<T> {
    typealias Item = T
    let items = Variable<[Item]>([])
    var lastFetched: Date?
    var page = 1
    var refreshInterval = 10.minutes
    var canFetchMore = true
    
    func fetch(page: Int) -> Promise<[T]> {
        return Promise(value: [])
    }
    
    func fetchMore() -> Promise<Void> {
        let page = self.page
        return self.fetch(page: page).then { items -> Void in
            if self.page == page {
                self.page += 1
                self.items.value += items
                self.canFetchMore = items.count > 0
            }
        }
    }
    
    func fetchAndReset() -> Promise<Void> {
        self.page = 1
        return self.fetch(page: 1).then { items -> Void in
            self.page = 2
            self.items.value = items
            self.canFetchMore = items.count > 0
            self.lastFetched = Date()
        }
    }
    
    func refresh() -> Promise<Void> {
        if let last = lastFetched {
            if Date() - refreshInterval < last {
                return Promise(value: ())
            }
        }
        return fetchAndReset()
    }
}
