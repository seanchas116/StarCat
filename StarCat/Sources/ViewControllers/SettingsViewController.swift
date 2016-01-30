//
//  SettingsViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/30.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import RxSwift

class SettingsViewController: UITableViewController {
    @IBOutlet weak var logoutCell: UITableViewCell!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.rx_tap.subscribeNext { [weak self] in
            self?.dismissViewControllerAnimated(true, completion: nil)
        }.addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell == logoutCell {
            print("logout")
        }
    }
}
