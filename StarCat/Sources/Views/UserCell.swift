
//
//  UserCell.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/02/20.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import Wirework
import Kingfisher

class UserCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    let viewModel = UserViewModel()
    let bag = SubscriptionBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewModel.avatarURL.bindTo { [weak self] link in
            self?.avatarImage.kf.setImage(with: link?.url)
        }.addTo(bag)
        viewModel.name.bindTo(fullNameLabel.wwText).addTo(bag)
        viewModel.login.bindTo(loginLabel.wwText).addTo(bag)
        let detail = viewModel.location
        detail.bindTo(detailLabel.wwText).addTo(bag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
