//
//  AttributedString.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/03/10.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit

func renderAttributedStringFromHTML(html: String, css: String) -> NSAttributedString? {
    let fullHTML = "<html><head><style>\(css)</style></head><body>\(html)</body></html>"
    return try? NSAttributedString(
        data: fullHTML.dataUsingEncoding(NSUTF8StringEncoding)!,
        options: [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSNumber(unsignedLong: NSUTF8StringEncoding)
        ],
        documentAttributes: nil
    )
}