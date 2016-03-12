//
//  String+SplitRegex.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/24.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation

extension String {
    func splitRegex(regex: String) -> [String] {
        do {
            let regEx = try NSRegularExpression(pattern: regex, options: NSRegularExpressionOptions())
            var parts: [String] = []
            var lastIndex = 0
            let count = utf16.count
            
            func appendPart(range: Range<Int>) {
                let strRange = utf16.startIndex.advancedBy(range.startIndex) ..< utf16.startIndex.advancedBy(range.endIndex)
                parts.append(String(utf16[strRange]))
            }
            
            regEx.enumerateMatchesInString(
                self, options: [], range: NSMakeRange(0, count)
            ) { result, flags, stop in
                let range = result!.range
                appendPart(lastIndex ..< range.location)
                lastIndex = range.location + range.length
            }
            appendPart(lastIndex ..< count)
            return parts
        } catch {
            return []
        }
    }
    
    func countLines() -> Int {
        var count = 0
        for c in self.characters {
            if c == "\n" {
                count += 1
            }
        }
        return count
    }
    
    func fillLeft(min: Int, by char: Character) -> String {
        let remaining = min - self.characters.count
        if remaining > 0 {
            return String(count: remaining, repeatedValue: char) + self
        } else {
            return self
        }
    }
}

extension Int {
    var digitsCount: Int {
        return Int(log10(Double(self))) + 1
    }
}