//
//  String.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/07.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import SwiftDate

extension NSDate {
    func formatForUI(withAgo withAgo: Bool) -> String {
        if NSDate() - 1.months < self {
            let formatted = self.toRelativeString() ?? ""
            if withAgo {
                return formatted + " ago"
            } else {
                return formatted
            }
        } else {
            let formatter = NSDateFormatter()
            formatter.dateStyle = .MediumStyle
            formatter.timeStyle = .NoStyle
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            return formatter.stringFromDate(self)
        }
    }
}
