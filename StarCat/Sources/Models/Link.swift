//
//  Link.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/19.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import Regex

let schemePattern = "^https?://"

struct Link {
    let URL: NSURL
    
    init?(string: String) {
        let trimmed = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if trimmed == "" {
            return nil
        }
        let withHTTP = trimmed.grep(schemePattern) ? trimmed : "http://\(trimmed)"
        if let URL = NSURL(string: withHTTP) {
            self.URL = URL
        } else {
            return nil
        }
    }
    
    init?(URL: NSURL) {
        self.init(string: URL.absoluteString!)
    }
}

extension Link {
    var string: String {
        return URL.absoluteString!
    }
    var stringWithoutScheme: String {
        return URL.absoluteString!.replaceRegex(schemePattern, with: "")
    }
}
