//
//  FileTableViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/03/06.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import Wirework

class FileCell: UITableViewCell {
    let viewModel = FileViewModel()
    let bag = SubscriptionBag()
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewModel.isDir.map { $0 ? "folder-24" : "file-24" }.map { UIImage(named: $0) }.bindTo(iconView.wwImage).addTo(bag)
        viewModel.name.bindTo(titleLabel.wwText).addTo(bag)
        viewModel.isDir.bindTo { [weak self] isDir in
            if isDir {
                self?.accessoryType = .DisclosureIndicator
            } else {
                self?.accessoryType = .None
            }
        }.addTo(bag)
    }
}

class FileTableViewController: UITableViewController {
    
    let viewModel = DirectoryViewModel()
    let bag = SubscriptionBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.files.bindTo(tableView.wwRows("FileCell") { row, file, cell in
            let fileCell = cell as! FileCell
            fileCell.viewModel.file.value = file
        }).addTo(bag)
        tableView.wwItemSelected.subscribe { [weak self] index in
            guard let this = self else { return }
            guard let repo = this.viewModel.repoName.value else { return }
            let file = this.viewModel.files.value[index.row]
            if file.type == .Dir {
                this.navigationController?.pushDirectory(file, repo: repo)
            }
        }.addTo(bag)
        viewModel.name.bindTo(wwTitle).addTo(bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
