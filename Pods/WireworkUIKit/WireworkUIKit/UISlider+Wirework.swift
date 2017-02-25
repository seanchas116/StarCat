//
//  UISlider.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/08.
//
//

import UIKit
import Wirework

extension UISlider {
    public var wwValue: (Float) -> Void {
        return { [weak self] in
            self?.value = $0
        }
    }
    
    public var wwValueChanged: Signal<Float> {
        return wwControlEvent(.valueChanged).map { [weak self] _ in self?.value ?? 0.0 }
    }
}
