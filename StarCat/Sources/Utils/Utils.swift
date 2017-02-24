//
//  String+SplitRegex.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/24.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation

extension String {
    func countLines() -> Int {
        var count = 1
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
            return String(repeating: String([char]), count: remaining) + self
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
