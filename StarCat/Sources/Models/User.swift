//
//  User.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/10.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation

enum UserType {
    case User
    case Organization
}

struct User {
    let type: UserType
    let id: Int
    let login: String
    let name: String?
    let avatarURL: NSURL
    let company: String?
    let location: String?
    let blog: NSURL?
    let email: String?
    let followers: Int
    let following: Int
}
