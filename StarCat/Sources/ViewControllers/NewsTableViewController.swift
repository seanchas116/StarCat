//
//  NewsTableViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/01.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsTableViewController: RepoTableViewController {
    
    let viewModel = NewsTabViewModel()
    let appeared = Variable(false)
    
    override func viewDidLoad() {
        pagination = viewModel.newsPagination
        
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().rx_notification(UIApplicationDidBecomeActiveNotification)
            .subscribeNext { [weak self] _ in
                print("activated")
                self?.paginator.refresh()
            }
            .addDisposableTo(disposeBag)
        
        AppViewModel.instance.tabViewModel.selectedIndex.subscribeNext { index in
            print(index)
            if index == 0 && self.appeared.value {
                print("scrolling")
                self.scrollToTop()
            }
        }.addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        appeared.value = true
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
