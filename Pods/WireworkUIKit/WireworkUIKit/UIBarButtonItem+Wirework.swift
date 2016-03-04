//
//  UIBarButtonItem+Wirework.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/03/03.
//
//

import UIKit
import Wirework

var targetKey = 0

class WWBarButtonItemTarget: NSObject {
    weak var _barButtonItem: UIBarButtonItem?
    let event = Event<Void>()
    #if MONITOR_RESOURCES
    private let _resourceMonitor = ResourceMonitor("WWBarButtonItemTarget")
    #endif
    
    init(barButtonItem: UIBarButtonItem) {
        _barButtonItem = barButtonItem
        super.init()
        barButtonItem.target = self
        barButtonItem.action = Selector("action")
    }
    
    func action() {
        event.emit()
    }
}

extension UIBarButtonItem {
    private var wwTarget: WWBarButtonItemTarget {
        return wwAssociatedObject(&targetKey) { WWBarButtonItemTarget(barButtonItem: self) }
    }
    
    public var wwTapped: Signal<Void> {
        return wwTarget.event
    }
}