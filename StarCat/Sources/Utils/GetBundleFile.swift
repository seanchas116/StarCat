//
//  GetBundleFile.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/03/09.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation

func getBundleFile(fileName: String, ofType: String) -> String {
    if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: ofType) {
        return (try? String(contentsOfFile: path, encoding: NSUTF8StringEncoding)) ?? ""
    }
    return ""
}