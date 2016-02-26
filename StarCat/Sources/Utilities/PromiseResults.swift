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
import Wirework

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

extension RequestType {
    func send() -> Promise<Response> {
        return Session.sendRequestPromise(self)
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

extension PropertyType {
    func mapAsync<T>(initValue: T, transform: (Value) -> Promise<T>) -> Property<T> {
        return mapAsync(initValue) { value, callback in transform(value).then(callback) }
    }
}