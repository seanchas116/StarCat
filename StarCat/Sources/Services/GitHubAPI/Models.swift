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
}