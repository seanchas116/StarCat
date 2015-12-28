//
//  NSURL+Queries.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2015/12/20.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import Foundation

extension NSURL {
    func getQueryParameter(param: String) -> String? {
        let url = NSURLComponents(URL: self, resolvingAgainstBaseURL: true)!
        if let items = url.queryItems {
            return items.filter { item in item.name == param }.first?.value
        }
        return nil
    }
    static func fromQueries(base: String, queries: [String:String]) -> NSURL {
        let queryStr = queries
            .map { (key, value) in "\(key)=\(value)" }
            .joinWithSeparator("&")
        return NSURL(string: "\(base)?\(queryStr)")!
    }
}
