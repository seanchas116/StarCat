//
//  Link.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/19.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import Regex

struct Link {
    let URL: NSURL
    var string: String { return URL.absoluteString }
    
    init?(string: String) {
        let trimmed = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if trimmed == "" {
            return nil
        }
        let withHTTP = trimmed.grep("^https?://") ? trimmed : "http://\(trimmed)"
        if let URL = NSURL(string: withHTTP) {
            self.URL = URL
        } else {
            return nil
        }
    }
    
    init?(URL: NSURL) {
        self.init(string: URL.absoluteString)
    }
}