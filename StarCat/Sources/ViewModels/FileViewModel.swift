//
//  FileViewModel.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/03/06.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import Wirework

class FileViewModel {
    let repoName = Variable<String?>(nil)
    let file = Variable<File?>(nil)
    let name: Property<String>
    let path: Property<String>
    let isDir: Property<Bool>
    let content = Variable<NSData?>(nil)
    
    init() {
        name = file.map { $0?.name ?? "" }
        path = file.map { $0?.path ?? "" }
        isDir = file.map { $0?.type == .Dir }
    }
    
    func loadContent() {
        guard let repoName = repoName.value else { return }
        guard let filePath = file.value?.path else { return }
        GetFileContentRequest(repoName: repoName, filePath: filePath).send().then { content in
            self.content.value = content.decoded
        }
    }
}