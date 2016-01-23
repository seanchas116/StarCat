//
//  File.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/22.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import StarCat

class LinkSpec: QuickSpec {
    override func spec() {
        
        describe("Link") {
            describe("string") {
                it("automatically appends http://") {
                    let link = Link(string: "example.com")!
                    expect(link.string).to(equal("http://example.com"))
                }
            }
        }
        
    }
}
