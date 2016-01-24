//
//  parseLinkHeaderSpec.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/24.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import StarCat

class UtilSpec: QuickSpec {
    override func spec() {
        
        describe("Util") {
            describe("parseLinkHeader") {
                it("parses HTTP link header"){
                    let linkHeader =
                    "<https://api.github.com/user/1025246/repos?page=3&per_page=100>; rel=\"next\", " +
                        "<https://api.github.com/user/1025246/repos?page=1&per_page=100>; rel=\"prev\"; pet=\"cat\", " +
                    "<https://api.github.com/user/1025246/repos?page=5&per_page=100>; rel=\"last\""
                    
                    let result = parseLinkHeader(linkHeader)
                    expect(result).to(equal([
                        "next": "https://api.github.com/user/1025246/repos?page=3&per_page=100",
                        "prev": "https://api.github.com/user/1025246/repos?page=1&per_page=100",
                        "last": "https://api.github.com/user/1025246/repos?page=5&per_page=100",
                        ]))
                }
            }
            
            describe("String+SplitRegEx") {
                it("split string by regex") {
                    expect("foo🍣, bar,    baz".splitRegEx(",\\s+")).to(equal(["foo🍣", "bar", "baz"]))
                }
            }
        }
    }
}
