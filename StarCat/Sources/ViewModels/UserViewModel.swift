//
//  UserViewModel.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/10.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import RxSwift
import Haneke
import PromiseKit

class UserViewModel {
    let user = Variable<User?>(nil)
    let summary = Variable<UserSummary?>(nil)
    let name = Variable("")
    let avatarImage = Variable<UIImage?>(nil)
    let login = Variable("")
    let location = Variable<String?>(nil)
    let homepage = Variable<NSURL?>(nil)
    let followersCount = Variable(0)
    let followingCount = Variable(0)
    let starsCount = Variable(0)
    
    func load() -> Promise<Void> {
        return User.fetch(login.value).then { self.setUser($0) }
    }
    
    func setSummary(summary: UserSummary) {
        self.login.value = summary.login
        self.summary.value = summary
        Shared.imageCache.fetch(URL: summary.avatarURL).promise().then { image -> Void in
            self.avatarImage.value = image
        }
    }
    
    func setUser(user: User) {
        name.value = user.name ?? user.login
        login.value = user.login
        location.value = user.location
        homepage.value = user.blog
        followersCount.value = user.followers
        followingCount.value = user.following
        Shared.imageCache.fetch(URL: user.avatarURL).promise().then { image -> Void in
            self.avatarImage.value = image
        }

        self.user.value = user
    }
}