import Foundation

public protocol PropertyType {
    associatedtype Value
    var changed: Signal<Value> { get }
    var value: Value { get }
}

public protocol MutablePropertyType: class, PropertyType {
    var value: Value { get set }
}

extension PropertyType {
    public func map<T>(_ transform: @escaping (Value) -> T) -> Property<T> {
        return createProperty(changed.map { transform($0) }) { transform(self.value) }
    }
    
    public func mapAsync<T>(_ initValue: T, transform: @escaping (Value, @escaping (T) -> Void) -> Void) -> Property<T> {
        var value = initValue
        let changed = EventWithBag<Void>()
        transform(self.value) { [weak changed] in
            value = $0
            changed?.emit()
        }
        self.changed.subscribe { [weak changed] origValue in
            transform(origValue) {
                value = $0
                changed?.emit()
            }
        }.addTo(changed.bag)
        return createProperty(changed) { value }
    }
    
    
    public func bindTo<T: MutablePropertyType>(_ dest: T) -> Subscription where T.Value == Value {
        return bindTo { dest.value = $0 }
    }
    
    
    public func bindTo<T: MutablePropertyType>(_ dest: T) -> Subscription where T.Value == Value? {
        return bindTo { dest.value = $0 }
    }
    
    
    public func bindTo(_ setter: @escaping (Value) -> Void) -> Subscription {
        setter(value)
        return changed.subscribe { newValue in
            setter(newValue)
        }
    }
}

extension PropertyType where Value: Equatable {
    public var distinct: Property<Value> {
        let changed: Signal<Value> = createSignal { bag, emit in
            var lastValue = self.value
            self.changed.subscribe { newValue in
                if lastValue != newValue {
                    lastValue = newValue
                    emit(newValue)
                }
            }.addTo(bag)
        }
        return createProperty(changed) { self.value }
    }
}

public func combine<P1: PropertyType, P2: PropertyType, V>(_ p1: P1, _ p2: P2, transform: @escaping (P1.Value, P2.Value) -> V) -> Property<V> {
    return createProperty(merge(p1.changed.voidSignal, p2.changed.voidSignal)) {
        transform(p1.value, p2.value)
    }
}

public func combine<P1: PropertyType, P2: PropertyType, P3: PropertyType, V>(_ p1: P1, _ p2: P2, _ p3: P3, transform: @escaping (P1.Value, P2.Value, P3.Value) -> V) -> Property<V> {
    return createProperty(merge(p1.changed.voidSignal, p2.changed.voidSignal, p3.changed.voidSignal)) {
        transform(p1.value, p2.value, p3.value)
    }
}
