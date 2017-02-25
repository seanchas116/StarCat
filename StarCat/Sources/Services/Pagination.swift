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
        self.page += 1
        return self.fetch(page: self.page).then { events -> Void in
            if events.count > 0 {
                self.items.value += events
            } else {
                self.canFetchMore = false
            }
        }
    }
    
    func fetchAndReset() -> Promise<Void> {
        return self.fetch(page: 1).then { events -> Void in
            self.page = 1
            self.items.value = events
            self.lastFetched = Date()
            self.canFetchMore = true
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
