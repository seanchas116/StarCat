//
//  Session+Promise.swift
//  StarCat
//
//  Created by 池上涼平 on 2015/12/28.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import Foundation
import PromiseKit
import APIKit

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