//
//  UIBarButtonItem+Wirework.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/03/03.
//
//

import UIKit
import Wirework

class WWBarButtonItemTarget: NSObject {
    weak var _barButtonItem: UIBarButtonItem?
    private let _callback: () -> Void
    #if MONITOR_RESOURCES
    private let _resourceMonitor = ResourceMonitor("WWBarButtonItemTarget")
    #endif
    
    init(barButtonItem: UIBarButtonItem, callback: () -> Void) {
        _barButtonItem = barButtonItem
        _callback = callback
        super.init()
        barButtonItem.target = self
        barButtonItem.action = Selector("action")
    }
    
    func action() {
        _callback()
    }
    
    deinit {
        _barButtonItem?.target = nil
        _barButtonItem?.action = nil
    }
}

extension UIBarButtonItem {
    public var wwTapped: Signal<Void> {
        return createSignal { bag, emit in
            let target = WWBarButtonItemTarget(barButtonItem: self, callback: emit)
            Subscription(object: target).addTo(bag)
        }
    }
}