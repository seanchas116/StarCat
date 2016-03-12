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
    private let highlightJS = getBundleFile("highlight.pack", ofType: "js")
    private let jsContext = JSContext()
    private let hasLanguage: JSValue
    private let highlight: JSValue
    private let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    
    init() {
        let global = jsContext.globalObject
        global.setValue(global, forProperty: "window")
        jsContext.evaluateScript(highlightJS)
        hasLanguage = jsContext.evaluateScript("(function(lang) { return !!hljs.getLanguage(lang); })")
        highlight = jsContext.evaluateScript("hljs.highlight")
    }
    
    func highlight(value: String, name: String) -> String {
        if let ext = name.componentsSeparatedByString(".").last {
            if hasLanguage.callWithArguments([ext]).toBool() {
                return highlight.callWithArguments([ext, value]).valueForProperty("value").toString()
            }
        }
        return value
    }
}

let highlighter = Highlighter()

func highlight(value: String, name: String) -> String {
    return highlighter.highlight(value, name: name)
}
