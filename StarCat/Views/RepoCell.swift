//
//  RepoCell.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2015/12/30.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RepoCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var eventInfoView: UIView!
    @IBOutlet weak var eventActorLabel: UILabel!
    @IBOutlet weak var eventVerbLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var disposeBag: DisposeBag!
    
    var viewModel: RepoViewModel! {
        didSet {
            disposeBag = DisposeBag()
            viewModel.name.bindTo(titleLabel.rx_text).addDisposableTo(disposeBag)
            viewModel.description.bindTo(descriptionLabel.rx_text).addDisposableTo(disposeBag)
            viewModel.avatarImage.bindTo(avatarImage.rx_image).addDisposableTo(disposeBag)
            viewModel.ownerName.bindTo(ownerNameLabel.rx_text).addDisposableTo(disposeBag)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = nil
    }
}
