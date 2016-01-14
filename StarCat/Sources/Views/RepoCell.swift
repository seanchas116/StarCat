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
    
    var disposeBag: DisposeBag!
    
    var viewModel: RepoViewModel! {
        didSet {
            disposeBag = DisposeBag()
            viewModel.name.bindTo(titleLabel.rx_text).addDisposableTo(disposeBag)
            viewModel.description.bindTo(descriptionLabel.rx_text).addDisposableTo(disposeBag)
            viewModel.avatarImage.bindTo(avatarImage.rx_image).addDisposableTo(disposeBag)
            viewModel.ownerName.bindTo(ownerNameLabel.rx_text).addDisposableTo(disposeBag)
            viewModel.event.map { $0 == nil }.bindTo(eventInfoView.rx_hidden).addDisposableTo(disposeBag)
            viewModel.eventActorName.bindTo(eventActorLabel.rx_text).addDisposableTo(disposeBag)
            viewModel.eventTime.map { $0?.formatForUI(withAgo: false) ?? "" }.bindTo(eventTimeLabel.rx_text).addDisposableTo(disposeBag)
            viewModel.language.map { l in l ?? "" }.shareReplay(1)
                .bindTo(languageLabel.rx_text).addDisposableTo(disposeBag)
            viewModel.language.map { l in l == nil }.shareReplay(1)
                .bindTo(languageLabel.rx_hidden).addDisposableTo(disposeBag)
            eventActorLabel.makeTappable().subscribeNext { [unowned self] _ in
                if let actor = self.viewModel.eventActor.value {
                    self.onActorTapped?(actor)
                }
            }.addDisposableTo(disposeBag)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = nil
    }
}
