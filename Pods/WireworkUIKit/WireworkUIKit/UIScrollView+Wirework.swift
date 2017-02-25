//
//  UIScrollView.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/09.
//
//

import UIKit
import Wirework

extension WWDelegateCascader: UIScrollViewDelegate {}

class WWScrollViewDelegate: NSObject, UIScrollViewDelegate {
    let cascaded = WWDelegateCascader()
    let didScroll = Event<CGPoint>()
    
    override init() {
        super.init()
        cascaded.first = self
    }
    
    func forward(to delegate: UIScrollViewDelegate?) {
        cascaded.second = delegate
    }
    
    func
        scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll.emit(scrollView.contentOffset)
    }
}

private var delegateKey = 0

extension UIScrollView {
    func installDelegate<T: WWScrollViewDelegate>(create: () -> T) -> T {
        let old = self.delegate
        let delegate = wwAssociatedObject(&delegateKey, create: create)
        self.delegate = delegate.cascaded
        if !(old is WWDelegateCascader) {
            delegate.forward(to: old)
        }
        return delegate
    }
    
    var wwDelegate: WWScrollViewDelegate {
        return installDelegate { WWScrollViewDelegate() }
    }
    
    public func wwForward(to delegate: UIScrollViewDelegate) {
        wwDelegate.forward(to: delegate)
    }
    
    public var wwScrollEnabled: (Bool) -> Void {
        return { [weak self] in
            self?.isScrollEnabled = $0
        }
    }
    
    public func wwContentOffset(animated: Bool) -> (CGPoint) -> Void {
        return { [weak self] in
            self?.setContentOffset($0, animated: animated)
        }
    }
    
    public var wwDidScroll: Signal<CGPoint> {
        return wwDelegate.didScroll
    }
}
