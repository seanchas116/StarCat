//
//  Signal.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/01.
//
//

import Foundation

public class Signal<T>: SignalType {
    #if MONITOR_RESOURCES
    private let _resourceMonitor = ResourceMonitor("Signal")
    #endif
    
    public typealias Value = T
    
    public var subscribersCount: Int {
        fatalError("not implemented")
    }
    
    public func addSubscriber(subscriber: Subscriber<Value>) {
        fatalError("not implemented")
    }
    
    public func removeSubscriber(subscriber: Subscriber<Value>) {
        fatalError("not implemented")
    }
}

public class Event<T>: Signal<T> {
    public typealias Value = T
    
    private var _subscribers = [Subscriber<Value>]()
    
    public override init() {
    }
    
    public override var subscribersCount: Int {
        return _subscribers.count
    }
    
    public func emit(value: T) {
        for subscriber in _subscribers {
            subscriber.callback(value)
        }
    }
    
    public override func addSubscriber(subscriber: Subscriber<Value>) {
        _subscribers.append(subscriber)
    }
    
    public override func removeSubscriber(subscriber: Subscriber<Value>) {
        _subscribers = _subscribers.filter { $0 !== subscriber }
    }
}

public class EventWithBag<T>: Event<T> {
    public let bag = SubscriptionBag()
}

public func createSignal<T>(subscribe: (SubscriptionBag, (T) -> Void) -> Void) -> Signal<T> {
    return AdapterSignal(subscribe)
}

private class AdapterSignal<T>: Signal<T> {
    private let _subscribe: (SubscriptionBag, (T) -> Void) -> Void
    private var _bag = SubscriptionBag()
    private let _event = Event<T>()
    
    init(_ subscribe: (SubscriptionBag, (T) -> Void) -> Void) {
        _subscribe = subscribe
    }
    
    override var subscribersCount: Int {
        return _event.subscribersCount
    }
    
    override func addSubscriber(subscriber: Subscriber<Value>) {
        _event.addSubscriber(subscriber)
        if _event.subscribersCount == 1 {
            _subscribe(_bag) { [weak self] in self?._event.emit($0) }
        }
    }
    
    override func removeSubscriber(subscriber: Subscriber<Value>) {
        _event.removeSubscriber(subscriber)
        if _event.subscribersCount == 0 {
            _bag = SubscriptionBag()
        }
    }
}
