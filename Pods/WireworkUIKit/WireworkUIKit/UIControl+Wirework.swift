import Foundation
import UIKit
import Wirework

class WWControlTarget: NSObject {
    weak var _control: UIControl?
    private let _callback: () -> Void
    #if MONITOR_RESOURCES
    private let _resourceMonitor = ResourceMonitor("WWControlTarget")
    #endif
    
    init(control: UIControl, events: UIControlEvents, callback: () -> Void) {
        _control = control
        _callback = callback
        super.init()
        control.addTarget(self, action: #selector(WWControlTarget.action), forControlEvents: events)
    }
    
    func action() {
        _callback()
    }
    
    deinit {
        _control?.removeTarget(self, action: nil, forControlEvents: UIControlEvents.AllEvents)
    }
}

extension UIControl {
    public func wwControlEvent(events: UIControlEvents) -> Signal<UIControlEvents> {
        return createSignal { bag, emit in
            let target = WWControlTarget(control: self, events: events) {
                emit(events)
            }
            Subscription(object: target).addTo(bag)
        }
    }
    
    public var wwEnabled: (Bool) -> Void {
        return { [weak self] in
            self?.enabled = $0
        }
    }
    
    public var wwSelected: (Bool) -> Void {
        return { [weak self] in
            self?.selected = $0
        }
    }
    
    public var wwHighlighted: (Bool) -> Void {
        return { [weak self] in
            self?.highlighted = $0
        }
    }
}