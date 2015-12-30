//
//  RepoViewModel.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2015/12/28.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import Foundation
import RxSwift
import APIKit
import Haneke

class RepoViewModel {
    let event = Variable<Event?>(nil)
    let name = Variable("")
    let starsCount = Variable(0)
    let description = Variable("")
    let language = Variable<String?>(nil)
    let avatarImage = Variable<UIImage?>(nil)
    
    init(repo: RepoSummary) {
        name.value = repo.fullName
        let repoRequest = GetRepoRequest(fullName: repo.fullName)
        Session.sendRequestPromise(repoRequest).then { repo -> Void in
            self.starsCount.value = repo.starsCount
            self.description.value = repo.description ?? ""
            self.language.value = repo.language
            Shared.imageCache.fetch(URL: repo.owner.avatarURL).promise().then { image -> Void in
                self.avatarImage.value = image
            }
        }
    }
}