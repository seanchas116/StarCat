//
//  ModelCache.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/14.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import PromiseKit
import SwiftDate

class ModelCacheEntry<T> {
    let item: T
    let addedAt: NSDate
    init(item: T) {
        self.item = item
        self.addedAt = NSDate()
    }
}

class ModelCache<T> {
    private let cache = NSCache()
    
    var expiry = 1.hours
    
    var countLimit: Int {
        get {
            return cache.countLimit
        }
        set {
            cache.countLimit = newValue
        }
    }
    
    var fetchNew: (String) -> Promise<T>
    
    init(fetchNew: (String) -> Promise<T>) {
        self.fetchNew = fetchNew
        self.countLimit = 100
    }
    
    func add(item: T, forKey key: String) {
        cache.setObject(ModelCacheEntry(item: item), forKey: key)
    }
    func fetch(key: String) -> Promise<T> {
        if let entry = cache.objectForKey(key) as? ModelCacheEntry<T> {
            if NSDate() - expiry < entry.addedAt {
                return Promise(entry.item)
            }
        }
        return self.fetchNew(key).then { item -> T in
            self.add(item, forKey: key)
            return item
        }
    }
}

struct SharedModelCache {
    static let repoCache = ModelCache<Repo>() { fullName in Repo.fetch(fullName) }
}