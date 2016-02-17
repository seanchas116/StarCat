//
//  SearchViewModel.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/17.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import Wirework
import PromiseKit

class SearchPagination: Pagination<RepoViewModel> {
    let query = Variable<String?>(nil)
    let bag = SubscriptionBag()
    
    override init() {
        super.init()
        query.bindTo { _ in
            self.fetchAndReset()
        }.addTo(bag)
    }
    
    override func fetch(page: Int) -> Promise<[RepoViewModel]> {
        if let query = query.value {
            return SearchRepoRequest(query: query, sort: .BestMatch, perPage: 30, page: page).send()
                .then { repos in repos.map { repo in RepoViewModel(repo: repo) } }
        } else {
            return Promise([])
        }
    }
}

class SearchViewModel {
    let pagination = SearchPagination()
}
