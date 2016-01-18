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
import SVWebViewController

private var popups = Set<WebViewPopup>()

class WebViewPopup: NSObject, SFSafariViewControllerDelegate {
    let root: UIViewController
    let URL: NSURL
    
    init(URL: NSURL, root: UIViewController) {
        self.root = root
        self.URL = URL
    }
    
    func show() {
        let safari = SFSafariViewController(URL: URL)
        safari.delegate = self
        popups.insert(self)
        root.presentViewController(safari, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        popups.remove(self)
    }
    
    func safariViewController(controller: SFSafariViewController, activityItemsForURL URL: NSURL, title: String?) -> [UIActivity] {
        let activities = WebViewPopup.activities
        for activity in activities {
            activity.prepareWithActivityItems([URL])
        }
        return activities
    }
    
    static func open(URL: NSURL, on vc: UIViewController) {
        WebViewPopup(URL: fixURL(URL), root: vc).show()
    }
    
    static func openActivity(URL: NSURL, on vc: UIViewController) {
        let activity = UIActivityViewController(activityItems: [URL], applicationActivities: activities)
        vc.presentViewController(activity, animated: true, completion: nil)
    }
    
    static var activities: [UIActivity] {
        return [SVWebViewControllerActivitySafari(), SVWebViewControllerActivityChrome()]
    }
}

func fixURL(URL: NSURL) -> NSURL {
    if !URL.absoluteString.grep("^https?") {
        return NSURL(string: "http://" + URL.absoluteString)!
    }
    return URL
}