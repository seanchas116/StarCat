//
//  FileSummary.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/03/06.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation

enum FileType {
    case File
    case Dir
}

struct File {
    let type: FileType
    let name: String
    let path: String
}

struct FileContent {
    let content: String
}