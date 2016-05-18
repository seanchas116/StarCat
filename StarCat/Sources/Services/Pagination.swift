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
    var lastFetched: NSDate?
    var page = 1
    var refreshInterval = 10.minutes
    var canFetchMore = true
    
    func fetch(page: Int) -> Promise<[T]> {
        return Promise([])
    }
    
    func fetchMore() -> Promise<Void> {
        self.page += 1
        return self.fetch(self.page).then { events -> Void in
            if events.count > 0 {
                self.items.value += events
            } else {
                self.canFetchMore = false
            }
        }
    }
    
    func fetchAndReset() -> Promise<Void> {
        return self.fetch(1).then { events -> Void in
            self.page = 1
            self.items.value = events
            self.lastFetched = NSDate()
            self.canFetchMore = true
        }
    }
    
    func refresh() -> Promise<Void> {
        if let last = lastFetched {
            if NSDate() - refreshInterval < last {
                return Promise()
            }
        }
        return fetchAndReset()
    }
}