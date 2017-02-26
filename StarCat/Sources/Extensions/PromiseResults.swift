//
//  PromiseResults.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2015/12/30.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import Foundation
import PromiseKit
import APIKit
import Wirework

extension Session {
    static func sendPromise<T: Request>(_ request: T) -> Promise<T.Response> {
        return Promise { fulfill, reject in
            send(request) { result in
                switch result {
                case .success(let res):
                    fulfill(res)
                case .failure(let err):
                    reject(err)
                }
            }
            return
        }
    }
}

extension Request {
    func send() -> Promise<Response> {
        return Session.sendPromise(self)
    }
}

