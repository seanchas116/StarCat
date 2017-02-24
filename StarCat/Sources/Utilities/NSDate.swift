//
//  String.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/07.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import SwiftDate

extension Date {
    func formatForUI(withAgo: Bool) -> String {
        if Date() - 1.months < self {
            let formatted = (try? self.colloquialSinceNow())?.colloquial ?? ""
            if withAgo {
                return formatted + " ago"
            } else {
                return formatted
            }
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            return formatter.string(from: self)
        }
    }
}
