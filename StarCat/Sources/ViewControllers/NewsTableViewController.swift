//
//  NewsTableViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/01.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import Wirework

class NewsTableViewController: RepoTableViewController {
    
    let viewModel = NewsTabViewModel()
    let appeared = Variable(false)
    
    override func viewDidLoad() {
        pagination = viewModel.newsPagination
        super.viewDidLoad()
        paginator.loading.value = true
        
        NSNotificationCenter.defaultCenter().wwNotification(UIApplicationDidBecomeActiveNotification, object: nil)
            .subscribe { [weak self] _ in
                print("activated")
                self?.paginator.refresh()
            }
            .addTo(bag)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        appeared.value = true
        if !Authentication.isLoggedIn {
            LoginButtonViewController.showOn(self)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        paginator.refresh()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        appeared.value = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
