//
//  Authentication.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2015/12/28.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import Foundation
import PromiseKit

private let redirectURL = "\(Constants.appURLScheme):///auth"

struct Authentication {
    static var accessToken: AccessToken?
    
    static var isLoggedIn: Bool {
        return accessToken != nil
    }
    
    static var authURL: URL {
        let options = [
            "client_id": Secrets.githubClientID,
            "redirect_uri": redirectURL,
            "scope": "user:follow,public_repo"
        ]
        return URL(string: "https://github.com/login/oauth/authorize?", queries: options)!
    }
    
    static func handleCallbackURL(_ url: URL) -> Promise<AccessToken> {
        if url.scheme == Constants.appURLScheme && url.path == "/auth" {
            if let code = url.queries["code"] {
                return GetAccessTokenRequest(code: code).send().then { accessToken -> AccessToken in
                    self.accessToken = accessToken
                    return accessToken
                }
            }
        }
        return Promise(error: "Cannot handle callback URL \(url)")
    }
}
