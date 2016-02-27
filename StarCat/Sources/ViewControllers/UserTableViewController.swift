//
//  UserTableViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/02/26.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import Wirework

class UserTableViewController: UITableViewController {
    
    var pagination: Pagination<User>!
    var paginator: TableViewPaginator<User>!
    let bag = SubscriptionBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        
        paginator = TableViewPaginator<User>(
            tableViewController: self,
            pagination: pagination,
            cellIdentifier: "UserCell"
        ) { row, user, cell in
            let userCell = cell as! UserCell
            userCell.viewModel.user.value = user
        }
        
        paginator.whenSelected.subscribe { [weak self] user in
            if let user = user {
                self?.navigationController?.pushUser(user)
            }
        }.addTo(bag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
