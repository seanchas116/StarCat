//
//  UIDatePicker.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/08.
//
//

import UIKit
import Wirework

extension UIDatePicker {
    public func wwDate(animated animated: Bool) -> (NSDate) -> Void {
        return { [weak self] in
            self?.setDate($0, animated: animated)
        }
    }
    public var wwDateChanged: Signal<NSDate> {
        return wwControlEvent(.ValueChanged).map { [weak self] _ in self?.date ?? NSDate() }
    }
}
