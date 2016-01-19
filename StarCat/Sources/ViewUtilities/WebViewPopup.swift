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
    let link: Link
    
    init(link: Link, root: UIViewController) {
        self.root = root
        self.link = link
    }
    
    func show() {
        let safari = SFSafariViewController(URL: link.URL)
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
    
    static func open(link: Link, on vc: UIViewController) {
        WebViewPopup(link: link, root: vc).show()
    }
    
    static func openActivity(link: Link, on vc: UIViewController) {
        let activity = UIActivityViewController(activityItems: [link.URL], applicationActivities: activities)
        vc.presentViewController(activity, animated: true, completion: nil)
    }
    
    static var activities: [UIActivity] {
        return [SVWebViewControllerActivitySafari(), SVWebViewControllerActivityChrome()]
    }
}

func fixURL(URL: NSURL) -> NSURL? {
    if !URL.absoluteString.grep("^https?") {
        return NSURL(string: "http://" + URL.absoluteString)
    }
    return URL
}