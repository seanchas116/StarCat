import Foundation

public class Subscription {
    private let _unsubscribe: () -> Void
    
    public init(unsubscribe: () -> Void) {
        _unsubscribe = unsubscribe
    }
    
    public func unsubscribe() {
        _unsubscribe()
    }
}

private func unused<T>(x: T) {}

extension Subscription {
    public convenience init(object: AnyObject) {
        var ref: AnyObject? = object
        unused(ref)
        self.init {
            ref = nil
        }
    }
    
    public func addTo(bag: SubscriptionBag) {
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

public class SubscriptionBag {
    private var _subscriptions = Set<Subscription>()
    
    public init() {
    }
    
    public func add(subscription: Subscription) {
        _subscriptions.insert(subscription)
    }
    
    public func remove(subscription: Subscription) {
        _subscriptions.remove(subscription)
    }
    
    deinit {
        for s in _subscriptions {
            s.unsubscribe()
        }
    }
}