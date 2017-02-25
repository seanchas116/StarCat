//
//  Link.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/19.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation

let schemePattern = "^https?://".r!

extension URL {
    var stringWithoutScheme: String {
        return schemePattern.replaceAll(in: absoluteString, with: "")
    }
}
