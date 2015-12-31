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
    
    func loadEvents() {
        let request = GetUserEventsRequest(userName: "seanchas116")
        Session.sendRequestPromise(request).then { events -> Promise<[RepoViewModel]> in
            let promises = events.flatMap { e -> Promise<RepoViewModel>? in
                switch e {
                case .Star(_, let repoSummary):
                    return RepoViewModel.fetchFromSummary(repoSummary).then { repo -> RepoViewModel in
                        repo.event.value = e
                        return repo
                    }
                default:
                    return nil
                }
            }
            return when(promises)
        }.then { events in
            self.repos.value = events
        }
    }
}