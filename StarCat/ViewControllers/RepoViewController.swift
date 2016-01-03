//
//  RepoViewController.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/03.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RepoViewController: UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var miscInfoLabel: UILabel!
    @IBOutlet weak var ownerButton: UIButton!
    
    let disposeBag = DisposeBag()
    var viewModel: RepoViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.name.bindTo(titleLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.description.bindTo(descriptionLabel.rx_text).addDisposableTo(disposeBag)
        viewModel.avatarImage.bindTo(avatarImageView.rx_image).addDisposableTo(disposeBag)
        viewModel.ownerName.subscribeNext { [weak self] name in
            self?.ownerButton.setTitle(name, forState: UIControlState.Normal)
        }.addDisposableTo(disposeBag)
        viewModel.homepage.subscribeNext { [weak self] url in
            self?.websiteButton.setTitle(url?.absoluteString ?? "", forState: UIControlState.Normal)
        }.addDisposableTo(disposeBag)
        viewModel.homepage.map { h in h == nil }.bindTo(websiteButton.rx_hidden).addDisposableTo(disposeBag)

        // Do any additional setup after loading the view.
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
