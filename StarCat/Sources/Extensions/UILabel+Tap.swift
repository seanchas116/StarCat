//
//  UILabel+Tap.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/10.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension UILabel {
    func makeTappable() -> ControlEvent<UIGestureRecognizer> {
        self.userInteractionEnabled = true
        let recognizer = UITapGestureRecognizer()
        self.addGestureRecognizer(recognizer)
        return recognizer.rx_event
    }
}
