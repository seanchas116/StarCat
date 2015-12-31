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
import PromiseKit

class RepoViewModel {
    let event = Variable<Event?>(nil)
    let name = Variable("")
    let starsCount = Variable(0)
    let description = Variable("")
    let language = Variable<String?>(nil)
    let avatarImage = Variable<UIImage?>(nil)
    let ownerName = Variable("")
    let eventActor: Observable<UserSummary?>
    let eventActorName: Observable<String>
    
    init() {
        eventActor = event.map { event in
            event.flatMap { e -> UserSummary? in
                switch e {
                case .Star(let user, _):
                    return user
                default:
                    return nil
                }
            }
        }.shareReplay(1)
        eventActorName = eventActor.map { actor in actor?.login ?? "" }.shareReplay(1)
    }
    
    static func fetchFromSummary(repo: RepoSummary) -> Promise<RepoViewModel> {
        let viewModel = RepoViewModel()
        let repoRequest = GetRepoRequest(fullName: repo.fullName)
        return Session.sendRequestPromise(repoRequest).then { repo -> RepoViewModel in
            viewModel.name.value = repo.name
            viewModel.starsCount.value = repo.starsCount
            viewModel.description.value = repo.description ?? ""
            viewModel.language.value = repo.language
            viewModel.ownerName.value = repo.owner.login
            Shared.imageCache.fetch(URL: repo.owner.avatarURL).promise().then { image -> Void in
                viewModel.avatarImage.value = image
            }
            
            return viewModel
        }
    }
}