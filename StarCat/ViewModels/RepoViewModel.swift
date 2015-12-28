//
//  RepoViewModel.swift
//  StarCat
//
//  Created by 池上涼平 on 2015/12/28.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import Foundation
import RxSwift
import APIKit

class RepoViewModel {
    let event = Variable<Event?>(nil)
    let name = Variable("")
    let starsCount = Variable(0)
    let description = Variable("")
    let language = Variable("")
    
    init(repo: RepoSummary) {
        name.value = repo.fullName
        let repoRequest = GetRepoRequest(fullName: repo.fullName)
        Session.sendRequestPromise(repoRequest).then { repo -> Void in
            self.starsCount.value = repo.starsCount
            self.description.value = repo.description
            self.language.value = repo.language
        }
    }
}