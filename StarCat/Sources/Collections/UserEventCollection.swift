//
//  UserEventCollection.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/14.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import PromiseKit

class UserEventCollection: Collection<RepoViewModel> {
    let userName: String
    
    init(userName: String) {
        self.userName = userName
    }
    
    override func fetch(page: Int) -> Promise<[Item]> {
        return Event.fetchForUser(userName, page: page).then { events -> Promise<[RepoViewModel]> in
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