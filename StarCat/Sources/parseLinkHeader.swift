//
//  ParseLinkHeader.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/24.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation

extension Dictionary {
    init<S: SequenceType where S.Generator.Element == (Key, Value)>(_ seq: S) {
        self.init()
        for (key, value) in seq {
            self[key] = value
        }
    }
}

func parseLinkHeader(header: String) -> [String: NSURL] {
    return [:]
}
