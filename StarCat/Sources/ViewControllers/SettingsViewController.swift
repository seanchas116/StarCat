//
//  SettingsViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/30.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import Wirework

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var logoutCell: UITableViewCell!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var feedbackCell: UITableViewCell!
    @IBOutlet weak var sourceCodeCell: UITableViewCell!
    
    let bag = SubscriptionBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.wwTapped.subscribe { [weak self] in
            self?.dismissViewControllerAnimated(true, completion: nil)
        }.addTo(bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) else { return }
        switch cell {
        case logoutCell:
            AppViewModel.instance.logout()
            dismissViewControllerAnimated(true, completion: nil)
        case feedbackCell:
            WebViewPopup.open(Link(string: "https://github.com/seanchas116/StarCat/issues/new")!, on: self)
        case sourceCodeCell:
            WebViewPopup.open(Link(string: "https://github.com/seanchas116/StarCat")!, on: self)
        default:
            break
        }
    }
}
