//
//  AppDelegate.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2015/12/19.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import UIKit
import KeychainAccess

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let keychain = Keychain(service: "com.seanchas116.starcat")
    
    private func loadAccessToken() -> AccessToken? {
        if let token = try? keychain.get("githubAccessToken"), scope = try? keychain.get("githubAccessScope") {
            if let token = token, scope = scope {
                return AccessToken(token: token, scope: scope)
            }
        }
        return nil
    }
    
    private func saveAccessToken(token: AccessToken) {
        do {
            try self.keychain.set(token.token, key: "githubAccessToken")
            try self.keychain.set(token.scope, key: "githubAccessScope")
        } catch _ {
            print("failed to set access token to keychain")
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Authentication.accessToken = loadAccessToken()
        
        // Override point for customization after application launch.
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 18)!]
        UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UINavigationBar.self])
            .setTitleTextAttributes([NSFontAttributeName: UIFont(name: "AvenirNext-Medium", size: 18)!], forState: .Normal)
        UINavigationBar.appearance().tintColor = UIColor.darkGrayColor()
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        if let tokenFetched = Authentication.handleCallbackURL(url) {
            tokenFetched.then { token -> Void in
                self.saveAccessToken(token)
                LoginButtonViewController.hideAll()
            }
            return true
        }
        return false
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

