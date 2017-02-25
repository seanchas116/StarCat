//
//  SearchViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/16.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import SwiftDate
import Wirework

class SearchViewController: RepoTableViewController, UISearchBarDelegate {
    
    var searchController: UISearchController!
    let viewModel = SearchViewModel()

    override func viewDidLoad() {
        pagination = viewModel.pagination
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        let searchBar = searchController.searchBar
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        navigationItem.titleView = searchBar
        
        definesPresentationContext = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.pagination.query = searchBar.text
        paginator.fetch()
    }
}
