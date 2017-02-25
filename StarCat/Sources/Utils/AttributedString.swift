//
//  AttributedString.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/03/10.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit

func renderAttributedStringFromHTML(_ html: String, css: String) -> NSAttributedString? {
    let fullHTML = "<html><head><style>\(css)</style></head><body>\(html)</body></html>"
    let data = fullHTML.data(using: String.Encoding.utf8, allowLossyConversion: true)!
    let options: [String: Any] = [
        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
        NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue
    ]
    return try? NSAttributedString(
        data: data,
        options: options,
        documentAttributes: nil
    )
}
