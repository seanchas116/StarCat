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
    private let jsContext = JSContext()!
    private let hasLanguage: JSValue
    private let highlight: JSValue
    
    init() {
        let global = jsContext.globalObject!
        global.setValue(global, forProperty: "window")
        jsContext.evaluateScript(highlightJS)
        hasLanguage = jsContext.evaluateScript("(function(lang) { return !!hljs.getLanguage(lang); })")
        highlight = jsContext.evaluateScript("hljs.highlight")
    }
    
    private func highlightSync(_ value: String, name: String) -> String {
        if let ext = name.components(separatedBy: ".").last {
            if hasLanguage.call(withArguments: [ext]).toBool() {
                return highlight.call(withArguments: [ext, value]).forProperty("value").toString()
            }
        }
        return value
    }
    
    func highlight(value: String, name: String) -> Promise<String> {
        return DispatchQueue.global().promise {
            self.highlightSync(value, name: name)
        }
    }
}

let highlighter = Highlighter()
