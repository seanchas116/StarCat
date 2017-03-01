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
        let locale = Locale(identifier: "en_US_POSIX")
        if Date() - 1.months < self {
            let region = Region(tz: .current, cal: .current, loc: locale)
            return (try? self.colloquialSinceNow(in: region))?.colloquial ?? ""
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            formatter.locale = locale
            return formatter.string(from: self)
        }
    }
}
