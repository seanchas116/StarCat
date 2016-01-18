//
//  RepoViewModel.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2015/12/28.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import Foundation
import RxSwift
import Haneke
import SwiftDate
import APIKit
import Alamofire

class RepoViewModel {
    let event = Variable<Event?>(nil)
    let name = Variable("")
    let fullName = Variable("")
    let starsCount = Variable(0)
    let description = Variable("")
    let language = Variable<String?>(nil)
    let avatarImage = Variable<UIImage?>(nil)
    let ownerName = Variable("")
    let homepage = Variable<NSURL?>(nil)
    let pushedAt = Variable(NSDate())
    let readme = Variable("")
    let githubURL = Variable<NSURL?>(nil)
    let eventActor = Variable<UserSummary?>(nil)
    let eventActorName = Variable<String>("")
    let eventTime = Variable<NSDate?>(nil)
    let disposeBag = DisposeBag()
    
    let repo: Repo
    
    init(repo: Repo) {
        self.repo = repo
        
        name.value = repo.name
        fullName.value = repo.fullName
        starsCount.value = repo.starsCount
        description.value = repo.description ?? ""
        language.value = repo.language
        ownerName.value = repo.owner.login
        homepage.value = repo.homepage
        pushedAt.value = repo.pushedAt
        
        fullName.map { NSURL(string: "https://github.com/\($0)") }.bindTo(githubURL).addDisposableTo(disposeBag)
        
        event.map { event in
            event.flatMap { e -> UserSummary? in
                switch e.content {
                case .Star(let user, _):
                    return user
                default:
                    return nil
                }
            }
        }.bindTo(eventActor).addDisposableTo(disposeBag)
        
        eventActor.map { $0?.login ?? "" }.bindTo(eventActorName).addDisposableTo(disposeBag)
        event.map { $0?.createdAt }.bindTo(eventTime).addDisposableTo(disposeBag)
        
        Shared.imageCache.fetch(URL: repo.owner.avatarURL).promise().then { image -> Void in
            self.avatarImage.value = image
        }
    }
    
    func fetchReadme() {
        Session.sendRequestPromise(GetReadmeRequest(fullName: "\(ownerName.value)/\(name.value)"))
            .then { readme in
                self.readme.value = readme
            }
    }
}