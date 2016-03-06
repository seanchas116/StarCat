//
//  DirectoryViewModel.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/03/06.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import Wirework
import PromiseKit

class DirectoryViewModel {
    let repoName = Variable<String?>(nil)
    let dirPath = Variable<String?>(nil)
    let files = Variable<[File]>([])
    let isLoading = Variable(false)
    let bag = SubscriptionBag()
    
    init() {
        merge(repoName.changed, dirPath.changed).subscribe { [weak self] _ in
            self?.updateFiles()
        }.addTo(bag)
    }
    
    func updateFiles() {
        guard let repoName = repoName.value else { return }
        guard let dirPath = dirPath.value else { return }
        isLoading.value = true
        GetDirectoryRequest(repoName: repoName, dirPath: dirPath).send().then { files -> Void in
            self.files.value = files
            self.isLoading.value = false
        }
    }
}
