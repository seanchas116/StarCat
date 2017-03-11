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

class SearchPagination: Pagination<Repo> {
    var query: String?
    let bag = SubscriptionBag()
    
    override func fetch(page: Int) -> Promise<[Repo]> {
        if let query = query {
            // for political reason we cannot show jailbreaking-related things
            if "[Jj]ailbreak".r!.matches(query) {
                return Promise(value: [])
            }
            return SearchRepoRequest(query: query, sort: .Stars, perPage: 30, page: page).send()
        } else {
            return Promise(value: [])
        }
    }
}

class SearchViewModel {
    let pagination = SearchPagination()
}
