//
//  AppViewModel.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/07.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import RxSwift

class AppViewModel {
    static let instance = AppViewModel()
    
    let currentUser = Variable<UserSummary?>(nil)
}