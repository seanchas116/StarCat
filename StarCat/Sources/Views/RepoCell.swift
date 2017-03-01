//
//  RepoCell.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2015/12/30.
//  Copyright © 2015年 seanchas116. All rights reserved.
//

import UIKit
import Wirework
import Kingfisher

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
    @IBOutlet weak var starsLabel: UILabel!
    
    let bag = SubscriptionBag()
    let viewModel = RepoViewModel()
    
    var onActorTapped: ((UserSummary) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        viewModel.name.bindTo(titleLabel.wwText).addTo(bag)
        viewModel.description.bindTo(descriptionLabel.wwText).addTo(bag)
        viewModel.avatarURL.bindTo { [weak self] url in
            self?.avatarImage.kf.setImage(with: url)
        }.addTo(bag)
        viewModel.ownerName.bindTo(ownerNameLabel.wwText).addTo(bag)
        viewModel.event.map { $0 == nil }.bindTo(eventInfoView.wwHidden).addTo(bag)
        viewModel.eventActorName.bindTo(eventActorLabel.wwText).addTo(bag)
        viewModel.eventTime.map { $0?.formatForUI(withAgo: false) ?? "" }.bindTo(eventTimeLabel.wwText).addTo(bag)
        viewModel.language.map { l in l ?? "" }.bindTo(languageLabel.wwText).addTo(bag)
        viewModel.language.map { l in l == nil }.bindTo(languageLabel.wwHidden).addTo(bag)
        viewModel.starsCount.map { "\($0) ★" }.bindTo(starsLabel.wwText).addTo(bag)
        eventActorLabel.makeTappable().subscribe { [unowned self] _ in
            if let actor = self.viewModel.eventActor.value {
                self.onActorTapped?(actor)
            }
        }.addTo(bag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
