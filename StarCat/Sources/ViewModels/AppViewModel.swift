//
//  AppViewModel.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/07.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import Wirework
import PromiseKit

class AppViewModel {
    static let instance = AppViewModel()

    let currentUser = Variable<User?>(nil)
    let keychainManager = KeychainManager()
    
    func tryLoginWithKeychain() -> Promise<Bool> {
        if let token = keychainManager.loadAccessToken() {
            Authentication.accessToken = token
            return loadCurrentUser().then { true }
        }
        return Promise(value: false)
    }
    
    func loginWithCallbackURL(_ url: URL) -> Promise<Void>? {
        if let tokenFetched = Authentication.handleCallbackURL(url) {
            return tokenFetched.then { token in
                self.keychainManager.saveAccessToken(token)
                return self.loadCurrentUser()
            }
        }
        return nil
    }
    
    func logout() {
        Authentication.accessToken = nil
        keychainManager.clearAccessToken()
        currentUser.value = nil
    }
    
    private func loadCurrentUser() -> Promise<Void> {
        return GetCurrentUserRequest().send().then { user in
            self.currentUser.value = user
        }
    }
}
