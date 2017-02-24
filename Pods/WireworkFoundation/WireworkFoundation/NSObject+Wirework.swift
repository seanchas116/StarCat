//
//  NSObject.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/04.
//
//

import Foundation
import Wirework

private var subscriptionBagKey = 0

class WWKeyValueObserver: NSObject {
    private let _object: NSObject
    private let _keyPath: String
    private let _callback: () -> Void
    private var _context = 0
    #if MONITOR_RESOURCES
    private let _resourceMonitor = ResourceMonitor("WWKeyValueObserver")
    #endif
    
    init(_ object: NSObject, _ keyPath: String, callback: @escaping () -> Void) {
        _object = object
        _keyPath = keyPath
        _callback = callback
        super.init()
        object.addObserver(self, forKeyPath: keyPath, options: .new, context: &_context)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &_context {
            _callback()
        }
    }
    
    deinit {
        _object.removeObserver(self, forKeyPath: _keyPath)
    }
}

extension NSObject {
    public func wwAssociatedObject<T: AnyObject>(_ key: UnsafeRawPointer, create: () -> T) -> T {
        if let obj = objc_getAssociatedObject(self, key) {
            return obj as! T
        } else {
            let obj = create()
            objc_setAssociatedObject(self, key, obj, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return obj
        }
    }
    
    public var wwBag: SubscriptionBag {
        return wwAssociatedObject(&subscriptionBagKey) { SubscriptionBag() }
    }
    
    public func wwKeyValue<T>(_ keyPath: String) -> MutableProperty<T> {
        let changed: Signal<Void> = createSignal { bag, emit in
            let observer = WWKeyValueObserver(self, keyPath, callback: emit)
            Subscription(object: observer).addTo(bag)
        }
        return createMutableProperty(changed,
            getValue: { self.value(forKeyPath: keyPath) as! T },
            setValue: { self.setValue($0 as AnyObject, forKeyPath: keyPath)}
        )
    }
}
