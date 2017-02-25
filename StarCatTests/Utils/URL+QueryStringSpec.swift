//
//  URL+QueryStringSpec.swift
//  StarCat
//
//  Created by 池上涼平 on 2017/02/25.
//  Copyright © 2017年 seanchas116. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import StarCat

class URLQueryStringSpec: QuickSpec {
    override func spec() {
        describe("URL+QueryString") {
            describe("queries") {
                it("return query map") {
                    let url = URL(string: "https://example.com?foo=bar&hoge=piyo")!
                    expect(url.queries).to(equal([
                        "foo": "bar",
                        "hoge": "piyo"
                    ]))
                }
            }
        }
    }
}
