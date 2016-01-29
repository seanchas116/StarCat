//
//  SearchViewModel.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/17.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import RxSwift
import PromiseKit

class SearchPagination: Pagination<RepoViewModel> {
    let query = Variable<String?>(nil)
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        query.subscribeNext { _ in
            self.fetchAndReset()
        }.addDisposableTo(disposeBag)
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
