import Foundation

open class Subscription {
    fileprivate let _unsubscribe: () -> Void
    
    public init(unsubscribe: @escaping () -> Void) {
        _unsubscribe = unsubscribe
    }
    
    open func unsubscribe() {
        _unsubscribe()
    }
}

private func unused<T>(_ x: T) {}

extension Subscription {
    public convenience init(object: AnyObject) {
        var ref: AnyObject? = object
        unused(ref)
        self.init {
            ref = nil
        }
    }
    
    public func addTo(_ bag: SubscriptionBag) {
        bag.add(self)
    }
}

extension Subscription: Equatable, Hashable {
    public var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
}

public func ==(left: Subscription, right: Subscription) -> Bool {
    return ObjectIdentifier(left) == ObjectIdentifier(right)
}

open class SubscriptionBag {
    fileprivate var _subscriptions = Set<Subscription>()
    
    public init() {
    }
    
    open func add(_ subscription: Subscription) {
        _subscriptions.insert(subscription)
    }
    
    open func remove(_ subscription: Subscription) {
        _subscriptions.remove(subscription)
    }
    
    deinit {
        for s in _subscriptions {
            s.unsubscribe()
        }
    }
}
