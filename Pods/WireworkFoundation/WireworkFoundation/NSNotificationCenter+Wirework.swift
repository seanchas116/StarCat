//
//  NSNotificationCenter.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/04.
//
//

import Foundation
import Wirework

extension NSNotificationCenter {
    public func wwNotification(name: String, object: AnyObject? = nil) -> Signal<NSNotification> {
        return createSignal { bag, emit in
            let observer = self.addObserverForName(name, object: object, queue: nil, usingBlock: {
                emit($0)
            })
            Subscription {
                self.removeObserver(observer)
            }.addTo(bag)
        }
    }
}
