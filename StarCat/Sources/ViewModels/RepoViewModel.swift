//
//  RepoViewModel.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2015/12/28.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import Foundation
import Wirework
import Haneke
import SwiftDate

class RepoViewModel {
    let event = Variable<Event?>(nil)
    let name = Variable("")
    let fullName = Variable("")
    let starsCount = Variable(0)
    let description = Variable("")
    let language = Variable<String?>(nil)
    let avatarImage = Variable<UIImage?>(nil)
    let ownerName = Variable("")
    let homepage = Variable<Link?>(nil)
    let pushedAt = Variable(NSDate())
    let readme = Variable("")
    let githubURL: Property<Link?>
    let eventActor: Property<UserSummary?>
    let eventActorName: Property<String>
    let eventTime: Property<NSDate?>
    
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
        
        githubURL = fullName.map { Link(string: "https://github.com/\($0)") }
        eventActor = event.map { event in
            event.flatMap { e -> UserSummary? in
                switch e.content {
                case .Star(let user, _):
                    return user
                default:
                    return nil
                }
            }
        }
        eventActorName = eventActor.map { $0?.login ?? "" }
        eventTime = event.map { $0?.createdAt }
        
        Shared.imageCache.fetch(URL: repo.owner.avatarURL.URL).promise().then { image -> Void in
            self.avatarImage.value = image
        }
    }
    
    func fetchReadme() {
        GetReadmeRequest(fullName: "\(ownerName.value)/\(name.value)").send()
            .then { readme in
                self.readme.value = readme
            }
    }
}