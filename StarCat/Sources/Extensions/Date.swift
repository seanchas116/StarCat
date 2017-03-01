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
    func formatForUI() -> String {
        if Date() - 1.months < self {
            return (try? self.colloquialSinceNow())?.colloquial ?? ""
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
            return formatter.string(from: self)
        }
    }
}
