//
//  NSNotificationCenter.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/04.
//
//

import Foundation
import Wirework

extension NotificationCenter {
    public func wwNotification(_ name: Notification.Name, object: AnyObject? = nil) -> Signal<Notification> {
        return createSignal { bag, emit in
            let observer = self.addObserver(forName: name, object: object, queue: nil, using: {
                emit($0)
            })
            Subscription {
                self.removeObserver(observer)
            }.addTo(bag)
        }
    }
}
