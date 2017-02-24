import Foundation

open class Property<T>: PropertyType {
    #if MONITOR_RESOURCES
    private let _resourceMonitor = ResourceMonitor("Property")
    #endif
    
    public typealias Value = T
    
    open var changed: Signal<T> {
        fatalError("not implemented")
    }
    open var value: Value {
        fatalError("not implemented")
    }
}

open class MutableProperty<T>: Property<T>, MutablePropertyType {
    open override var value: Value {
        get { fatalError("not implemented") }
        set { fatalError("not implemented") }
    }
}

open class Variable<T>: MutableProperty<T> {
    fileprivate var _value: Value
    fileprivate let _changed = Event<T>()
    
    open override var changed: Signal<T> {
        return _changed
    }
    
    open override var value: Value {
        get { return _value }
        set {
            _value = newValue
            _changed.emit(newValue)
        }
    }

    public init(_ value: Value) {
        _value = value
    }
}


public func createProperty<T>(_ changedSignal: Signal<T>, getValue: @escaping () -> T) -> Property<T> {
    return AdapterProperty(changedSignal, getValue)
}

public func createProperty<T>(_ changedSignal: Signal<Void>, getValue: @escaping () -> T) -> Property<T> {
    return AdapterProperty(changedSignal.map(getValue), getValue)
}

private class AdapterProperty<T>: Property<T> {
    fileprivate let _getValue: () -> T
    fileprivate let _changed: Signal<T>
    
    init(_ changed: Signal<T>, _ getValue: @escaping () -> T) {
        _getValue = getValue
        _changed = changed
    }
    
    override var changed: Signal<T> {
        return _changed
    }
    
    override var value: T {
        return _getValue()
    }
}

public func createMutableProperty<T>(_ changedSignal: Signal<T>, getValue: @escaping () -> T, setValue: @escaping (T) -> Void) -> MutableProperty<T> {
    return AdapterMutableProperty(changedSignal, getValue, setValue)
}

public func createMutableProperty<T>(_ changedSignal: Signal<Void>, getValue: @escaping () -> T, setValue: @escaping (T) -> Void) -> MutableProperty<T> {
    return AdapterMutableProperty(changedSignal.map(getValue), getValue, setValue)
}

private class AdapterMutableProperty<T>: MutableProperty<T> {
    fileprivate let _getValue: () -> T
    fileprivate let _setValue: (T) -> Void
    fileprivate let _changed: Signal<T>
    
    init(_ changed: Signal<T>, _ getValue: @escaping () -> T, _ setValue: @escaping (T) -> Void) {
        _getValue = getValue
        _setValue = setValue
        _changed = changed
    }
    
    override var changed: Signal<T> {
        return _changed
    }
    
    override var value: T {
        get {
            return _getValue()
        }
        set {
            _setValue(newValue)
        }
    }
}
