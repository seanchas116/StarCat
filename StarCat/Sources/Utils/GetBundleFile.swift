//
//  GetBundleFile.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/03/09.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation

func getBundleFile(_ fileName: String, ofType: String) -> String {
    if let path = Bundle.main.path(forResource: fileName, ofType: ofType) {
        return (try? String(contentsOfFile: path, encoding: String.Encoding.utf8)) ?? ""
    }
    return ""
}
