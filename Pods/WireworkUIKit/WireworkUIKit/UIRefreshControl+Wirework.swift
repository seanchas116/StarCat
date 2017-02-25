//
//  UIRefreshControl.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/08.
//
//

import Foundation
import Wirework

extension UIRefreshControl {
    public var wwRefreshing: (Bool) -> Void {
        return { [weak self] in
            if $0 {
                self?.beginRefreshing()
            } else {
                self?.endRefreshing()
            }
        }
    }
    
    public var wwRefreshingChanged: Signal<Bool> {
        return wwControlEvent(.valueChanged).map { [weak self] _ in self?.isRefreshing ?? false }
    }
}
