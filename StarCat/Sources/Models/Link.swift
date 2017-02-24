//
//  Link.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/19.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation

let schemePattern = "^https?://".r!

struct Link {
    let url: URL
    
    init?(string: String) {
        let trimmed = string.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if trimmed == "" {
            return nil
        }
        let withHTTP = schemePattern.matches(trimmed) ? trimmed : "http://\(trimmed)"
        if let url = URL(string: withHTTP) {
            self.url = url
        } else {
            return nil
        }
    }
    
    init?(url: URL) {
        self.init(string: url.absoluteString)
    }
}

extension Link {
    var string: String {
        return url.absoluteString
    }
    var stringWithoutScheme: String {
        return schemePattern.replaceAll(in: url.absoluteString, with: "")
    }
}
