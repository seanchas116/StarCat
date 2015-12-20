//
//  AppDelegate.swift
//  StarCat
//
//  Created by 池上涼平 on 2015/12/19.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import UIKit
import KeychainAccess

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let keychain = Keychain(service: "com.seanchas116.starcat")


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        print("init")
        let token = keychain["githubToken"];
        if token == nil {
            let githubAuthURL = NSURL.fromQueries("https://github.com/login/oauth/authorize", queries: [
                "client_id": Constants.githubClientID,
                "redirect_uri": "\(Constants.appURLScheme):///auth",
            ])
            UIApplication.sharedApplication().openURL(githubAuthURL)
        }
        
        // Override point for customization after application launch.
        return true
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        print(url)
        if url.scheme == Constants.appURLScheme {
            if url.path == "/auth" {
                let code = url.getQueryParameter("code")!
                print("code \(code)")
            }
            print("hoge")
        }
        return true
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

