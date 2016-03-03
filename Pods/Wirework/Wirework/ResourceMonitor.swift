//
//  ResourceMonitor.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/06.
//
//

import Foundation

private var _totalCount = 0

public class ResourceMonitor {
    private let _type: String
    
    public init(_ type: String) {
        _type = type
        _totalCount += 1
    }
    
    deinit {
        _totalCount -= 1
    }
    
    public static var totalCount: Int {
        return _totalCount
    }
}