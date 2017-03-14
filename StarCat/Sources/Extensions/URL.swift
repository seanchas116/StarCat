//
//  URL.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/19.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation


func parseQueryString(_ string: String) -> [String: String] {
    let keyValues = string.components(separatedBy: "&")
    var results = [String: String]()
    if keyValues.count > 0 {
        for pair in keyValues {
            let kv = pair.components(separatedBy: "=")
            if kv.count > 1 {
                results.updateValue(kv[1], forKey: kv[0])
            }
        }
        
    }
    return results
}

func stringifyQueryString(_ params: [String: Any]) -> String {
    return params.map { "\($0)=\($1)" }.joined(separator: "&")
}

let schemePattern = "^https?://".r!


extension URL {
    init?(string: String, queries: [String: Any]) {
        self.init(string: "\(string)?\(stringifyQueryString(queries))")
    }
    
    init?(stringMaybeWithoutScheme: String) {
        let str = schemePattern.matches(stringMaybeWithoutScheme)
            ? stringMaybeWithoutScheme
            : "http://" + stringMaybeWithoutScheme
        self.init(string: str)
    }
    
    var queries: [String: String] {
        return parseQueryString(query ?? "")
    }
    
    var fragments: [String: String] {
        return parseQueryString(fragment ?? "")
    }
    
    var stringWithoutScheme: String {
        return schemePattern.replaceAll(in: absoluteString, with: "")
    }
}
