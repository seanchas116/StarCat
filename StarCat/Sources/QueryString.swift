//
//  NSURL+.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/27.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation

func parseQueryString(string: String) -> [String: String] {
    let keyValues = string.componentsSeparatedByString("&")
    var results = [String: String]()
    if keyValues.count > 0 {
        for pair in keyValues {
            let kv = pair.componentsSeparatedByString("=")
            if kv.count > 1 {
                results.updateValue(kv[1], forKey: kv[0])
            }
        }
        
    }
    return results
}

func stringifyQueryString(params: [String: AnyObject]) -> String {
    return params.map { "\($0)=\($1)" }.joinWithSeparator("&")
}

extension NSURL {
    var queries: [String: String] {
        return parseQueryString(query ?? "")
    }
    var fragments: [String: String] {
        return parseQueryString(fragment ?? "")
    }
    convenience init?(string: String, queries: [String: AnyObject]) {
        self.init(string: "\(string)?\(stringifyQueryString(queries))")
    }
}