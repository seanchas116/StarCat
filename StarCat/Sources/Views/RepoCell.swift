//
//  RepoCell.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2015/12/30.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import UIKit
import Wirework

class RepoCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var eventInfoView: UIView!
    @IBOutlet weak var eventActorLabel: UILabel!
    @IBOutlet weak var eventVerbLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    
    var onActorTapped: ((UserSummary) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var bag: SubscriptionBag!
    
    var viewModel: RepoViewModel! {
        didSet {
            bag = SubscriptionBag()
            viewModel.name.bindTo(titleLabel.wwText).addTo(bag)
            viewModel.description.bindTo(descriptionLabel.wwText).addTo(bag)
            viewModel.avatarImage.bindTo(avatarImage.wwImage).addTo(bag)
            viewModel.ownerName.bindTo(ownerNameLabel.wwText).addTo(bag)
            viewModel.event.map { $0 == nil }.bindTo(eventInfoView.wwHidden).addTo(bag)
            viewModel.eventActorName.bindTo(eventActorLabel.wwText).addTo(bag)
            viewModel.eventTime.map { $0?.formatForUI(withAgo: false) ?? "" }.bindTo(eventTimeLabel.wwText).addTo(bag)
            viewModel.language.map { l in l ?? "" }.bindTo(languageLabel.wwText).addTo(bag)
            viewModel.language.map { l in l == nil }.bindTo(languageLabel.wwHidden).addTo(bag)
            eventActorLabel.makeTappable().subscribe { [unowned self] _ in
                if let actor = self.viewModel.eventActor.value {
                    self.onActorTapped?(actor)
                }
            }.addTo(bag)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.bag = nil
    }
}
