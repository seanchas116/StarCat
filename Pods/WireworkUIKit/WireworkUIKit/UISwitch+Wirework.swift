//
//  UISwitch.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/08.
//
//

import Foundation
import Wirework

extension UISwitch {
    public func wwOn(animated: Bool) -> (Bool) -> Void {
        return { [weak self] in
            self?.setOn($0, animated: animated)
        }
    }
    
    public var wwOnChanged: Signal<Bool> {
        return wwControlEvent(.valueChanged).map { [weak self] _ in self?.isOn ?? false }
    }
}
