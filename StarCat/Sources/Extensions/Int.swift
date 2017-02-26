//
//  Int.swift
//  StarCat
//
//  Created by 池上涼平 on 2017/02/26.
//  Copyright © 2017年 seanchas116. All rights reserved.
//

import Foundation

extension Int {
    var digitsCount: Int {
        return Int(log10(Double(self))) + 1
    }
}
