//
//  UISegmentedControl.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/08.
//
//

import UIKit
import Wirework

extension UISegmentedControl {
    public var wwSelectedSegmentIndex: (Int) -> Void {
        return { [weak self] in
            self?.selectedSegmentIndex = $0
        }
    }
    
    public var wwSelectedSegmentIndexChanged: Signal<Int> {
        return wwControlEvent(.valueChanged).map { [weak self] _ in self?.selectedSegmentIndex ?? 0 }
    }
}
