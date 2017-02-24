//
//  WebViewPopup.swift
//  StarCat
//
//  Created by Ryohei Ikegami on 2016/01/16.
//  Copyright © 2016年 seanchas116. All rights reserved.
//

import Foundation
import SafariServices
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
        let safari = SFSafariViewController(url: link.url)
        safari.delegate = self
        popups.insert(self)
        root.present(safari, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        popups.remove(self)
    }
    
    func safariViewController(_ controller: SFSafariViewController, activityItemsFor url: URL, title: String?) -> [UIActivity] {
        let activities = WebViewPopup.activities
        for activity in activities {
            activity.prepare(withActivityItems: [url])
        }
        return activities
    }
    
    static func open(_ link: Link, on vc: UIViewController) {
        WebViewPopup(link: link, root: vc).show()
    }
    
    static func openActivity(_ link: Link, on vc: UIViewController) {
        let activity = UIActivityViewController(activityItems: [link.url], applicationActivities: activities)
        vc.present(activity, animated: true, completion: nil)
    }
    
    static var activities: [UIActivity] {
        return [SVWebViewControllerActivitySafari(), SVWebViewControllerActivityChrome()]
    }
}

