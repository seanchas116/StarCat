//
//  Repo.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2015/12/23.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import Foundation

struct Repo {
    let id: Int
    let owner: UserSummary
    let name: String
    let fullName: String
    let description: String?
    let starsCount: Int
    let language: String?
    let homepage: Link?
    let pushedAt: NSDate
}
