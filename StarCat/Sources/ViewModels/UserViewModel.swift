//
//  UserViewModel.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/10.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import Wirework
import PromiseKit

class UserRepoPagination: Pagination<Repo> {
    var userName: String?
    
    override func fetch(page: Int) -> Promise<[Repo]> {
        if let userName = userName {
            return SearchRepoRequest(query: "user:\(userName)", sort: .Stars, perPage: 30, page: page).send()
        } else {
            return Promise(value: [])
        }
    }
}

func fetchUsersDetail(summaries: [UserSummary]) -> Promise<[User]> {
    let promises = summaries.map { s in SharedModelCache.userCache.fetch(key: s.login) }
    return when(fulfilled: promises)
}

class FollowersPagination: Pagination<User> {
    var userName: String?
    
    override func fetch(page: Int) -> Promise<[User]> {
        if let userName = userName {
            return GetFollowersRequest(userName: userName, perPage: 30, page: page).send()
                .then(execute: fetchUsersDetail)
        } else {
            return Promise(value: [])
        }
    }
}

class FollowingPagination: Pagination<User> {
    var userName: String?
    
    override func fetch(page: Int) -> Promise<[User]> {
        if let userName = userName {
            return GetFollowingRequest(userName: userName, perPage: 30, page: page).send()
                .then(execute: fetchUsersDetail)
        } else {
            return Promise(value: [])
        }
    }
}

class MembersPagination: Pagination<User> {
    var organizationName: String?
    
    override func fetch(page: Int) -> Promise<[User]> {
        if let orgName = organizationName {
            return GetMembersRequest(organizationName: orgName, perPage: 30, page: page).send()
                .then(execute: fetchUsersDetail)
        } else {
            return Promise(value: [])
        }
    }
}

class StarsPagination: Pagination<Repo> {
    var userName: String?
    
    override func fetch(page: Int) -> Promise<[Repo]> {
        if let userName = userName {
            return GetUserStarsRequest(userName: userName, perPage: 30, page: page).send().then { repos in
                let promises = repos.map { r in SharedModelCache.repoCache.fetch(key: r.fullName) }
                return when(fulfilled: promises)
            }
        } else {
            return Promise(value: [])
        }
    }
}

class UserViewModel {
    let user = Variable<User?>(nil)
    let summary = Variable<UserSummary?>(nil)
    let name: Property<String>
    let avatarURL: Property<Link?>
    let login: Property<String>
    let company: Property<String?>
    let location: Property<String?>
    let homepage: Property<Link?>
    let followersCount: Property<Int>
    let followingCount: Property<Int>
    let starsCount = Variable(0)
    let githubURL: Property<Link?>
    let followed = Variable(false)
    
    let bag = SubscriptionBag()
    
    init() {
        let summary = combine(user, self.summary) { $0?.summary ?? $1 }
        login = summary.map { $0?.login ?? "" }
        name = user.map { $0?.name ?? $0?.login ?? "" }
        avatarURL = user.map { $0?.avatarURL }
        company = user.map { $0?.company }
        location = user.map { $0?.location }
        homepage = user.map { $0?.blog }
        followersCount = user.map { $0?.followers ?? 0 }
        followingCount = user.map { $0?.following ?? 0 }
        githubURL = login.map { Link(string: "https://github.com/\($0)") }
        
        summary.changed.subscribe { [weak self] summary in
            if let summary = summary {
                GetUserStarsCountRequest(userName: summary.login).send().then { count in
                    self?.starsCount.value = count
                }.catch { print($0) }
            }
        }.addTo(bag)
        
        user.bindTo { [weak self] user in
            if let userName = user?.login {
                CheckFollowedRequest(userName: userName).send().then { followed in
                    self?.followed.value = followed
                }.catch { print($0) }
            }
        }.addTo(bag)
    }
    
    func load() -> Promise<Void> {
        return GetUserRequest(login: login.value).send().then { self.user.value = $0 }
    }
    
    func loadCurrentUser() -> Promise<Void> {
        return GetCurrentUserRequest().send().then { self.user.value = $0 }
    }
    
    func toggleFollowed() -> Promise<Void> {
        if let userName = self.user.value?.login {
            if self.followed.value {
                return UnfollowRequest(userName: userName).send().then { _ -> Void in
                    self.followed.value = false
                }
            } else {
                return FollowRequest(userName: userName).send().then { _ -> Void in
                    self.followed.value = true
                }
            }
        }
        return Promise(value: ())
    }
}
