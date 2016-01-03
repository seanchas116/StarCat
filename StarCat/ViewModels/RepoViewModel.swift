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
    let homepage = Variable<NSURL?>(nil)
    let eventActor: Observable<UserSummary?>
    let eventActorName: Observable<String>
    
    let repo: Repo
    
    init(repo: Repo) {
        self.repo = repo
        
        name.value = repo.name
        starsCount.value = repo.starsCount
        description.value = repo.description ?? ""
        language.value = repo.language
        ownerName.value = repo.owner.login
        homepage.value = repo.homepage

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
        
        Shared.imageCache.fetch(URL: repo.owner.avatarURL).promise().then { image -> Void in
            self.avatarImage.value = image
        }
    }
}