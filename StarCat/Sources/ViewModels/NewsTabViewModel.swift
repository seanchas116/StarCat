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

class NewsPagination: Pagination<RepoViewModel> {
    let userName: String
    
    init(userName: String) {
        self.userName = userName
    }
    
    override func fetch(page: Int) -> Promise<[Item]> {
        return GetUserEventsRequest(userName: "seanchas116", page: page).send().then { events -> Promise<[RepoViewModel]> in
            let promises = events.flatMap { e -> Promise<RepoViewModel>? in
                switch e.content {
                case .Star(_, let repoSummary):
                    return SharedModelCache.repoCache.fetch(repoSummary.fullName).then { repo -> RepoViewModel in
                        let vm = RepoViewModel(repo: repo)
                        vm.event.value = e
                        return vm
                    }
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