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

class Paginator<T> {
    typealias Item = T
    let items = Variable<[Item]>([])
    var lastFetched: NSDate?
    var page = 1
    var refreshInterval = 10.minutes
    
    func fetch(page: Int) -> Promise<[T]> {
        return Promise([])
    }
    
    func fetchMore() -> Promise<Void> {
        return self.fetch(self.page).then { events -> Void in
            self.items.value += events
            self.page += 1
        }
    }
    
    func fetchAndReset() -> Promise<Void> {
        return self.fetch(1).then { events -> Void in
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