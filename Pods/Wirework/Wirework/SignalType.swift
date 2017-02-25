import Foundation

open class Subscriber<T> {
    let callback: (T) -> Void
    
    init(callback: @escaping ((T) -> Void)) {
        self.callback = callback
    }
}

public protocol SignalType {
    associatedtype Value
    
    func addSubscriber(_ subscriber: Subscriber<Value>)
    func removeSubscriber(_ subscriber: Subscriber<Value>)
}

extension SignalType {
    
    
    public func subscribe(_ callback: @escaping (Value) -> Void) -> Subscription {
        let subscriber = Subscriber(callback: callback)
        addSubscriber(subscriber)
        return Subscription {
            self.removeSubscriber(subscriber)
        }
    }
    
    public func map<T>(_ transform: @escaping (Value) -> T) -> Signal<T> {
        return createSignal { bag, emit in
            self.subscribe { value in
                emit(transform(value))
            }.addTo(bag)
        }
    }
    
    public func mapAsync<T>(_ transform: @escaping (Value, (T) -> Void) -> Void) -> Signal<T> {
        let event = EventWithBag<T>()
        subscribe { [weak event] value in
            transform(value) { event?.emit($0) }
        }.addTo(event.bag)
        return event
    }
    
    public func filter(_ predicate: @escaping (Value) -> Bool) -> Signal<Value> {
        return createSignal { bag, emit in
            self.subscribe { value in
                if predicate(value) {
                    emit(value)
                }
            }.addTo(bag)
        }
    }
    
    public var voidSignal: Signal<Void> {
        return map { _ in }
    }
}

public func merge<T: SignalType, U: SignalType>(_ s1: T, _ s2: U) -> Signal<T.Value> where T.Value == U.Value {
    return createSignal { bag, emit in
        s1.subscribe { emit($0) }.addTo(bag)
        s2.subscribe { emit($0) }.addTo(bag)
    }
}

public func merge<T: SignalType, U: SignalType, V: SignalType>(_ s1: T, _ s2: U, _ s3: V) -> Signal<T.Value> where T.Value == U.Value, U.Value == V.Value {
    return createSignal { bag, emit in
        s1.subscribe { emit($0) }.addTo(bag)
        s2.subscribe { emit($0) }.addTo(bag)
        s3.subscribe { emit($0) }.addTo(bag)
    }
}
