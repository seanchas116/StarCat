//
//  LoginButtonViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/28.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import Wirework

class LoginButtonViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    let bag = SubscriptionBag()
    private var onLoggedIn: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.wwTapped.subscribe { _ in
            UIApplication.sharedApplication().openURL(Authentication.authURL)
        }.addTo(bag)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    static var all = Set<LoginButtonViewController>()
    
    static func instantiate() -> LoginButtonViewController? {
        return UIStoryboard(name: "LoginButton", bundle: nil).instantiateInitialViewController() as? LoginButtonViewController
    }
    
    static func showOn(viewController: UIViewController) {
        if let navVC = viewController.navigationController {
            if let loginButtonVC = instantiate() {
                all.insert(loginButtonVC)
                navVC.viewControllers = [loginButtonVC]
                loginButtonVC.onLoggedIn = {
                    navVC.viewControllers = [viewController]
                    all.remove(loginButtonVC)
                }
            }
        }
    }
    
    static func hideAll() {
        for vc in all {
            vc.onLoggedIn?()
        }
        all.removeAll()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
