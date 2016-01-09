//
//  TextView.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/08.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import UIKit
import PromiseKit

class ReadmeTextView: UITextView {
    private var finishLoading: (() -> Void)?
    
    func loadContent(content: NSAttributedString?) -> Promise<Void> {
        return Promise { fulfill, reject in
            self.finishLoading = fulfill
            attributedText = content
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let finish = finishLoading {
            print("finished")
            finish()
            finishLoading = nil
        }
    }
}
