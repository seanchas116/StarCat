//
//  KeychainManager.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/30.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import KeychainAccess

private let githubTokenKey = "githubAccessToken"
private let githubScopeKey = "githubAccessScope"

class KeychainManager {
    let keychain = Keychain(service: "com.seanchas116.starcat")
    
    func loadAccessToken() -> AccessToken? {
        let token = keychain[githubTokenKey]
        let scope = keychain[githubScopeKey]
        if let token = token, scope = scope {
            return AccessToken(token: token, scope: scope)
        } else {
            return nil
        }
    }
    
    func saveAccessToken(token: AccessToken) {
        self.keychain[githubTokenKey] = token.token
        self.keychain[githubScopeKey] = token.token
    }
    
    func clearAccessToken() throws {
        self.keychain[githubTokenKey] = nil
        self.keychain[githubScopeKey] = nil
    }
}