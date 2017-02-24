//
//  Signal.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/01.
//
//

import Foundation

open class Signal<T>: SignalType {
    #if MONITOR_RESOURCES
    private let _resourceMonitor = ResourceMonitor("Signal")
    #endif
    
    public typealias Value = T
    
    open var subscribersCount: Int {
        fatalError("not implemented")
    }
    
    open func addSubscriber(_ subscriber: Subscriber<Value>) {
        fatalError("not implemented")
    }
    
    open func removeSubscriber(_ subscriber: Subscriber<Value>) {
        fatalError("not implemented")
    }
}

open class Event<T>: Signal<T> {
    public typealias Value = T
    
    fileprivate var _subscribers = [Subscriber<Value>]()
    
    public override init() {
    }
    
    open override var subscribersCount: Int {
        return _subscribers.count
    }
    
    open func emit(_ value: T) {
        for subscriber in _subscribers {
            subscriber.callback(value)
        }
    }
    
    open override func addSubscriber(_ subscriber: Subscriber<Value>) {
        _subscribers.append(subscriber)
    }
    
    open override func removeSubscriber(_ subscriber: Subscriber<Value>) {
        _subscribers = _subscribers.filter { $0 !== subscriber }
    }
}

open class EventWithBag<T>: Event<T> {
    open let bag = SubscriptionBag()
}

public func createSignal<T>(_ subscribe: @escaping (SubscriptionBag, @escaping (T) -> Void) -> Void) -> Signal<T> {
    return AdapterSignal(subscribe)
}

private class AdapterSignal<T>: Signal<T> {
    fileprivate let _subscribe: (SubscriptionBag, @escaping (T) -> Void) -> Void
    fileprivate var _bag = SubscriptionBag()
    fileprivate let _event = Event<T>()
    
    init(_ subscribe: @escaping (SubscriptionBag, @escaping (T) -> Void) -> Void) {
        _subscribe = subscribe
    }
    
    override var subscribersCount: Int {
        return _event.subscribersCount
    }
    
    override func addSubscriber(_ subscriber: Subscriber<Value>) {
        _event.addSubscriber(subscriber)
        if _event.subscribersCount == 1 {
            _subscribe(_bag) { [weak self] in self?._event.emit($0) }
        }
    }
    
    override func removeSubscriber(_ subscriber: Subscriber<Value>) {
        _event.removeSubscriber(subscriber)
        if _event.subscribersCount == 0 {
            _bag = SubscriptionBag()
        }
    }
}
