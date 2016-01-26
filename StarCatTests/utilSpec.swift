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
            
            describe("String+SplitRegEx") {
                it("split string by regex") {
                    expect("foo🍣, bar,    baz".splitRegex(",\\s+")).to(equal(["foo🍣", "bar", "baz"]))
                }
            }
        }
    }
}