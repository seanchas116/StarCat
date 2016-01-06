//
//  NewsTabViewModel.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2015/12/27.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import Foundation
import RxSwift
import APIKit
import PromiseKit
import SwiftDate

private class RepoCacheEntry {
    let repo: Repo
    let addedAt: NSDate
    init(repo: Repo) {
        self.repo = repo
        self.addedAt = NSDate()
    }
}

private class RepoCache {
    private let cache = NSCache()
    
    init() {
        cache.countLimit = 100
    }
    
    func add(repo: Repo) {
        cache.setObject(RepoCacheEntry(repo: repo), forKey: repo.fullName)
    }
    func fetch(fullName: String) -> Promise<Repo> {
        if let entry = cache.objectForKey(fullName) as? RepoCacheEntry {
            if NSDate() - 1.hours < entry.addedAt {
                return Promise(entry.repo)
            }
        }
        return Repo.fetch(fullName).then { repo -> Repo in
            self.add(repo)
            return repo
        }
    }
    
    static let instance = RepoCache()
}

class NewsTabViewModel {
    let repos = Variable<[RepoViewModel]>([])
    var lastFetched: NSDate?
    var page = 1
    
    func fetchMoreEvents() -> Promise<Void> {
        return Event.fetchForUser("seanchas116", page: page).then { events -> Promise<[RepoViewModel]> in
            let promises = events.flatMap { e -> Promise<RepoViewModel>? in
                switch e.content {
                case .Star(_, let repoSummary):
                    return RepoCache.instance.fetch(repoSummary.fullName).then { repo -> RepoViewModel in
                        let vm = RepoViewModel(repo: repo)
                        vm.event.value = e
                        return vm
                    }
                default:
                    return nil
                }
            }
            return when(promises)
        }.then { events -> Void in
            self.repos.value += events
            self.lastFetched = NSDate()
            self.page += 1
        }
    }
    
    func fetchEvents() -> Promise<Void> {
        page = 1
        repos.value = []
        return fetchMoreEvents()
    }
    
    func refreshEvents() -> Promise<Void> {
        if let last = lastFetched {
            if NSDate() - 10.minutes < last {
                return Promise()
            }
        }
        return fetchEvents()
    }
}