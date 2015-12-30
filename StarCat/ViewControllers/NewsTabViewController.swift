//
//  NewsTabViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2015/12/30.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsTabViewController: UIViewController {

    @IBOutlet var reposView: UITableView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reposView.estimatedRowHeight = 68.0
        reposView.rowHeight = UITableViewAutomaticDimension
        reposView.registerNib(UINib(nibName: "RepoCell", bundle: nil), forCellReuseIdentifier: "RepoCell")

        let viewModel = NewsTabViewModel()
        
        viewModel.repos.bindTo(reposView.rx_itemsWithCellIdentifier("RepoCell")) { row, elem, cell in
            (cell as! RepoCell).viewModel = elem
        }.addDisposableTo(disposeBag)
        
        viewModel.repos.subscribeNext { repos in
            print("repos updated")
            for repo in repos {
                print(repo.name.value)
            }
        }
        viewModel.loadEvents()
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
