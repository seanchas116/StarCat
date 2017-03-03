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

class UserViewModel {
    let user = Variable<User?>(nil)
    let summary = Variable<UserSummary?>(nil)
    let name: Property<String>
    let avatarURL: Property<URL?>
    let login: Property<String>
    let company: Property<String?>
    let location: Property<String?>
    let homepage: Property<URL?>
    let followersCount: Property<Int>
    let followingCount: Property<Int>
    let starsCount = Variable(0)
    let githubURL: Property<URL?>
    let followed = Variable(false)
    let membersCount = Variable(0)
    
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
        githubURL = login.map { URL(string: "https://github.com/\($0)") }
    }
    
    func loadMiscInfo() -> Promise<Void> {
        guard let summary = summary.value else {
            print("summary is empty")
            return Promise(value: ())
        }
        if summary.type == .user {
            return when(fulfilled: [
                GetUserStarsCountRequest(userName: summary.login).send().then { count in
                    self.starsCount.value = count
                },
                CheckFollowedRequest(userName: summary.login).send().then { followed in
                    self.followed.value = followed
                }
            ])
        } else {
            return when(fulfilled: [
                GetMemberCountRequest(organizationName: summary.login).send().then { count in
                    self.membersCount.value = count
                }
            ])
        }
    }
    
    func loadFrom(user: User) -> Promise<Void> {
        self.summary.value = user.summary
        self.user.value = user
        return loadMiscInfo()
    }
    
    func loadFrom(summary: UserSummary) -> Promise<Void> {
        self.summary.value = summary
        return when(fulfilled: [
            GetUserRequest(login: summary.login).send().then { user in
                self.user.value = user
            },
            loadMiscInfo()
        ])
    }
    
    func loadCurrentUser() -> Promise<Void> {
        return GetCurrentUserRequest().send().then { user in
            self.loadFrom(user: user)
        }
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
