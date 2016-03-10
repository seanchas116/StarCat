//
//  FileViewModel.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/03/06.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import Wirework
import PromiseKit

class FileViewModel {
    let repoName = Variable<String?>(nil)
    let file = Variable<File?>(nil)
    let name: Property<String>
    let path: Property<String>
    let isDir: Property<Bool>
    
    init() {
        name = file.map { $0?.name ?? "" }
        path = file.map { $0?.path ?? "" }
        isDir = file.map { $0?.type == .Dir }
    }
    
    func loadContent() -> Promise<NSData> {
        guard let repoName = repoName.value else { return Promise(error: "no repoName") }
        guard let filePath = file.value?.path else { return Promise(error: "no filePath") }
        return GetFileContentRequest(repoName: repoName, filePath: filePath).send().then { content in
            content.decoded ?? NSData()
        }
    }
}