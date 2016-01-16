//
//  WebViewPopup.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/16.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import SafariServices
import Regex

class WebViewPopup: NSObject, SFSafariViewControllerDelegate {
    let root: UIViewController
    let url: NSURL
    
    init(url: NSURL, root: UIViewController) {
        self.root = root
        self.url = url
    }
    
    func show() {
        let safari = SFSafariViewController(URL: url)
        safari.delegate = self
        root.presentViewController(safari, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        root.dismissViewControllerAnimated(true, completion: nil)
    }
    
    static func open(origURL: NSURL, root: UIViewController) {
        var newURL: NSURL?
        if !origURL.absoluteString.grep("^https?") {
            newURL = NSURL(string: "http://" + origURL.absoluteString)
        } else {
            newURL = origURL
        }
        if let url = newURL {
            WebViewPopup(url: url, root: root).show()
        }
    }
}