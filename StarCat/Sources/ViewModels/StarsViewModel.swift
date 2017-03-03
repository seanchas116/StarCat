//
//  StarsViewModel.swift
//  StarCat
//
//  Created by 池上涼平 on 2017/03/03.
//  Copyright © 2017年 seanchas116. All rights reserved.
//

import Foundation
import Wirework
import PromiseKit

class StarsPagination: Pagination<Repo> {
    var userName: String?
    
    override func fetch(page: Int) -> Promise<[Repo]> {
        guard let userName = userName else {
            return Promise(value: [])
 
        }
        return GetUserStarsRequest(userName: userName, perPage: 30, page: page).send().then { repos in
            let promises = repos.map { r in SharedModelCache.repoCache.fetch(key: r.fullName) }
            return when(fulfilled: promises)
        }
    }
}

class StarsViewModel {
    let pagination = StarsPagination()
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
