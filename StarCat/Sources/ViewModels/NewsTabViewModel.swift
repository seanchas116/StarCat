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
    let userName: String
    
    init(userName: String) {
        self.userName = userName
    }
    
    override func fetch(page: Int) -> Promise<[Item]> {
        return GetUserEventsRequest(userName: "seanchas116", page: page).send().then { events -> Promise<[News]> in
            let promises = events.flatMap { event -> Promise<News>? in
                switch event.content {
                case .Star(_, let repoSummary):
                    return SharedModelCache.repoCache.fetch(repoSummary.fullName)
                        .then { repo in News(repo: repo, event: event) }
                default:
                    return nil
                }
            }
            return when(promises)
        }
    }
}

class NewsTabViewModel {
    let newsPagination = NewsPagination(userName: "seanchas116")
}