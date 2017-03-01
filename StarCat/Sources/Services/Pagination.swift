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
        return self.fetch(page: self.page).then { items -> Void in
            self.page += 1
            self.lastFetched = Date()
            if items.count > 0 {
                self.items.value += items
            } else {
                self.canFetchMore = false
            }
        }
    }
    
    func fetchAndReset() -> Promise<Void> {
        page = 1
        items.value = []
        canFetchMore = true
        return fetchMore()
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
