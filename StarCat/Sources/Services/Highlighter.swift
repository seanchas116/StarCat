//
//  Highlight.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/03/10.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import JavaScriptCore
import PromiseKit

struct Highlighter {
    private let highlightJS = getBundleFile("highlight.min", ofType: "js")
    private let jsContext = JSContext()
    private let highlightAuto: JSValue
    private let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    
    init() {
        let global = jsContext.globalObject
        global.setValue(global, forProperty: "window")
        jsContext.evaluateScript(highlightJS)
        let hljs = global.valueForProperty("hljs")
        highlightAuto = hljs.valueForProperty("highlightAuto")
    }
    
    func highlight(value: String, name: String) -> String {
        let result = highlightAuto.callWithArguments([value])
        return result.valueForProperty("value").toString()
    }
}

let highlighter = Highlighter()

func highlight(value: String, name: String) -> String {
    return highlighter.highlight(value, name: name)
}
