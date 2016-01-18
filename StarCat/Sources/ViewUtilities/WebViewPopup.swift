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
    
    static func open(url: NSURL, onViewController vc: UIViewController) {
        WebViewPopup(url: fixURL(url), root: vc).show()
    }
    
    static func openActivity(url: NSURL, on vc: UIViewController) {
        let activity = UIActivityViewController(activityItems: [url], applicationActivities: activities)
        vc.presentViewController(activity, animated: true, completion: nil)
    }
    
    static var activities: [UIActivity] {
        return []
    }
}

func fixURL(url: NSURL) -> NSURL {
    if !url.absoluteString.grep("^https?") {
        return NSURL(string: "http://" + url.absoluteString)!
    }
    return url
}