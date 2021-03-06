//
//  Event.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2015/12/23.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import Foundation

struct Event {
    let content: EventContent
    let createdAt: Date
}

enum EventContent {
    case Star(UserSummary, RepoSummary)
    case Unknown
}
