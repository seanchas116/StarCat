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
import Haneke

extension Session {
    static func sendRequestPromise<T: RequestType>(request: T) -> Promise<T.Response> {
        return Promise { fulfill, reject in
            sendRequest(request) { result in
                switch result {
                case .Success(let res):
                    fulfill(res)
                case .Failure(let err):
                    reject(err)
                }
            }
            return
        }
    }
}

extension Fetch {
    func promise() -> Promise<T> {
        return Promise { fulfill, reject in
            self.onSuccess(fulfill)
            self.onFailure { failure in
                reject(failure!)
            }
        }
    }
}