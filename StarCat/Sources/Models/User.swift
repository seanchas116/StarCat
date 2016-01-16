//
//  User.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/10.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation

struct User {
    let type: String
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
