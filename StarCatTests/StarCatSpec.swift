//
//  StarCatTests.swift
//  StarCatTests
//
//  Created by Ryohei Ikegami on 2015/12/19.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import StarCat

class StarCatSpec: QuickSpec {
    override func spec() {
        describe("StarCat") {
            describe("spec") {
                it("works fine") {
                    expect(true).to(beTruthy())
                }
            }
        }
    }
}
