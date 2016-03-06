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
    let file = Variable<File?>(nil)
    let name: Property<String>
    let path: Property<String>
    let isDir: Property<Bool>
    
    init() {
        name = file.map { $0?.name ?? "" }
        path = file.map { $0?.path ?? "" }
        isDir = file.map { $0?.type == .Dir }
    }
}