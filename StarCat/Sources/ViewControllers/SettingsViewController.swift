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
            self?.dismiss(animated: true, completion: nil)
        }.addTo(bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        switch cell {
        case logoutCell:
            AppViewModel.instance.logout()
            dismiss(animated: true, completion: nil)
        case feedbackCell:
            WebViewPopup.open(URL(string: "https://github.com/seanchas116/StarCat/issues/new")!, on: self)
        case sourceCodeCell:
            WebViewPopup.open(URL(string: "https://github.com/seanchas116/StarCat")!, on: self)
        default:
            break
        }
    }
}
