//
//  StarsNavigationController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/05/16.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import Wirework

class StarsNavigationController: UINavigationController {
    
    let bag = SubscriptionBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repoTableVC = topViewController as! RepoTableViewController
        let pagination = StarsPagination()
        repoTableVC.pagination = pagination
        repoTableVC.title = "Stars"
        tabBarItem.title = ""
        
        AppViewModel.instance.currentUser.bindTo { user in
            if user?.login != "" {
                pagination.userName = user?.login
                pagination.fetchAndReset()
            }
        }.addTo(bag)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if !Authentication.isLoggedIn {
            LoginButtonViewController.showOn(topViewController!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
