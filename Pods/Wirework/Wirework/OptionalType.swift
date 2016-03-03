import Foundation

public protocol OptionalType {
    typealias Wrapped
    var _unbox: Optional<Wrapped> { get }
    init(_ some: Wrapped)
    init()
}

extension Optional: OptionalType {
    
    public var _unbox: Optional<Wrapped> {
        return self
    }
}
