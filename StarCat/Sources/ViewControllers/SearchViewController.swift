//
//  SearchViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/16.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import RxSwift
import SwiftDate

class SearchViewController: RepoTableViewController, UISearchResultsUpdating {
    
    var searchController: UISearchController!
    let viewModel = SearchViewModel()

    override func viewDidLoad() {
        pagination = viewModel.pagination
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        navigationItem.titleView = searchController.searchBar
        searchController.searchBar.rx_text
            .debounce(1, MainScheduler.sharedInstance)
            .subscribeNext { [unowned self] query in
                self.viewModel.pagination.query.value = query
            }
            .addDisposableTo(disposeBag)
        
        definesPresentationContext = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        // TODO
    }
}
