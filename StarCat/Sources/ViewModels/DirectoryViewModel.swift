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

class DirectoryViewModel: FileViewModel {
    let files = Variable<[File]>([])
    let isLoading = Variable(false)
    let bag = SubscriptionBag()
    
    override init() {
        super.init()
        merge(repoName.changed.voidSignal, file.changed.voidSignal).subscribe { [weak self] _ in
            self?.updateFiles()
        }.addTo(bag)
    }
    
    func updateFiles() {
        guard let repoName = repoName.value else { return }
        guard let path = file.value?.path else { return }
        isLoading.value = true
        GetDirectoryRequest(repoName: repoName, dirPath: path).send().then { files -> Void in
            self.files.value = files
            self.isLoading.value = false
        }
    }
}
