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

class NewsTabViewModel {
    let repos = Variable<[RepoViewModel]>([])
    
    func loadEvents() {
        let request = GetUserEventsRequest(userName: "seanchas116")
        Session.sendRequestPromise(request).then { events -> Void in
            self.repos.value = events.flatMap { e -> RepoViewModel? in
                switch e {
                case .Star(_, let repoSummary):
                    return RepoViewModel(repo: repoSummary)
                default:
                    return nil
                }
            }
        }
    }
}