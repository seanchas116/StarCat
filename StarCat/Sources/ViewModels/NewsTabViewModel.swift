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

class NewsTabViewModel {
    let repos = Variable<[RepoViewModel]>([])
    var count = 0
    
    func loadEvents() -> Promise<Void> {
        let request = GetUserEventsRequest(userName: "seanchas116")
        return Session.sendRequestPromise(request).then { events -> Promise<[RepoViewModel]> in
            let promises = events.flatMap { e -> Promise<RepoViewModel>? in
                switch e {
                case .Star(_, let repoSummary):
                    return Repo.fetch(repoSummary.fullName).then { repo -> RepoViewModel in
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
            self.repos.value = events
        }
    }
}