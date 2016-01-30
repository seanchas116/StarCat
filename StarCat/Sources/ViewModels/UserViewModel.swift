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

class UserRepoPagination: Pagination<RepoViewModel> {
    var userName: String?
    
    override func fetch(page: Int) -> Promise<[RepoViewModel]> {
        if let userName = userName {
            return SearchRepoRequest(query: "user:\(userName)", sort: .Stars, perPage: 30, page: page).send()
                .then { repos in repos.map { repo in RepoViewModel(repo: repo) } }
        } else {
            return Promise([])
        }
    }
}

class UserViewModel {
    let user = Variable<User?>(nil)
    let summary = Variable<UserSummary?>(nil)
    let name = Variable("")
    let avatarImage = Variable<UIImage?>(nil)
    let login = Variable("")
    let location = Variable<String?>(nil)
    let homepage = Variable<Link?>(nil)
    let followersCount = Variable(0)
    let followingCount = Variable(0)
    let starsCount = Variable(0)
    let githubURL = Variable<Link?>(nil)
    
    let disposeBag = DisposeBag()
    
    init() {
        login
            .map { Link(string: "https://github.com/\($0)") }
            .bindTo(githubURL)
            .addDisposableTo(disposeBag)
    }
    
    func load() -> Promise<Void> {
        return GetUserRequest(login: login.value).send().then { self.setUser($0) }
    }
    
    func loadCurrentUser() -> Promise<Void> {
        return GetCurrentUserRequest().send().then { self.setUser($0) }
    }
    
    func setSummary(summary: UserSummary) {
        self.login.value = summary.login
        self.summary.value = summary
        Shared.imageCache.fetch(URL: summary.avatarURL.URL).promise().then { image -> Void in
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
        Shared.imageCache.fetch(URL: user.avatarURL.URL).promise().then { image -> Void in
            self.avatarImage.value = image
        }
        GetUserStarsCountRequest(userName: user.login).send().then { starsCount in
            self.starsCount.value = starsCount
        }

        self.user.value = user
    }
}