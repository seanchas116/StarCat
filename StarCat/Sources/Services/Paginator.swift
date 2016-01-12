//
//  Paginator.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/11.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit
import SwiftDate

protocol PaginatorSource {
    typealias Item
    var perPage: Int { get }
    func fetch(page: Int) -> Promise<[Item]>
}

class Paginator<T: PaginatorSource> {
    let fetcher: T
    let items = Variable<[T.Item]>([])
    var lastFetched: NSDate?
    var page = 1
    var refreshInterval = 10.minutes
    
    init(fetcher: T) {
        self.fetcher = fetcher
    }
    
    func fetchMore() -> Promise<Void> {
        return self.fetcher.fetch(self.page).then { events -> Void in
            self.items.value += events
            self.page += 1
        }
    }
    
    func fetchAndReset() -> Promise<Void> {
        return self.fetcher.fetch(1).then { events -> Void in
            self.page = 1
            self.items.value = []
            self.lastFetched = NSDate()
        }
    }
    
    func refresh() -> Promise<Void> {
        if let last = lastFetched {
            if NSDate() - refreshInterval < last {
                return Promise()
            }
        }
        return fetchMore()
    }
}