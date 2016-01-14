//
//  Models.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/03.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import APIKit
import PromiseKit

extension Repo {
    static func fetch(fullName: String) -> Promise<Repo> {
        return Session.sendRequestPromise(GetRepoRequest(fullName: fullName))
    }
    static func search(query: String, sort: String, perPage: Int, page: Int) -> Promise<[Repo]> {
        return Session.sendRequestPromise(SearchRepoRequest(query: query, sort: sort, perPage: perPage, page: page))
    }
}

extension Event {
    static func fetchForUser(nae: String, page: Int) -> Promise<[Event]> {
        let request = GetUserEventsRequest(userName: "seanchas116", page: page)
        return Session.sendRequestPromise(request)
    }
}

extension User {
    static func fetch(login: String) -> Promise<User> {
        return Session.sendRequestPromise(GetUserRequest(login: login))
    }
}