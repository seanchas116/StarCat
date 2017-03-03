//
//  NewsTabViewModel.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2015/12/27.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import Foundation
import Wirework
import PromiseKit
import SwiftDate

class NewsPagination: Pagination<News> {
    var userName: String?
    
    override func fetch(page: Int) -> Promise<[Item]> {
        guard let userName = userName else {
            return Promise(value: [])
        }
        return GetUserEventsRequest(userName: userName, page: page).send().then { events -> Promise<[News]> in
            let promises = events.flatMap { event -> Promise<News>? in
                switch event.content {
                case .Star(_, let repoSummary):
                    return SharedModelCache.repoCache.fetch(key: repoSummary.fullName)
                        .then { repo in News(repo: repo, event: event) }
                default:
                    return nil
                }
            }
            return when(fulfilled: promises)
        }
    }
}

class NewsViewModel {
    let pagination = NewsPagination()
    let bag = SubscriptionBag()
    
    init() {
        AppViewModel.instance.currentUser.bindTo { [weak self] user in
            if let login = user?.login {
                self?.pagination.userName = login
                self?.pagination.fetchAndReset().catch { print($0) }
            }
        }.addTo(bag)
    }
}
