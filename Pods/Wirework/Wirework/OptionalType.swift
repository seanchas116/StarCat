import Foundation

public protocol OptionalType {
    associatedtype Wrapped
    var _unbox: Optional<Wrapped> { get }
    init(_ some: Wrapped)
}

extension Optional: OptionalType {
    public var _unbox: Optional<Wrapped> {
        return self
    }
}
