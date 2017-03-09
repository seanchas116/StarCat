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


class WebViewPopup: NSObject, SFSafariViewControllerDelegate {
    let root: UIViewController
    let url: URL
    var safariViewController: SFSafariViewController?
    static var popups = Set<WebViewPopup>()
    
    init(url: URL, root: UIViewController) {
        self.root = root
        self.url = url
    }
    
    func show() {
        let safari = SFSafariViewController(url: url)
        self.safariViewController = safari
        safari.delegate = self
        WebViewPopup.popups.insert(self)
        root.present(safari, animated: true, completion: nil)
    }
    
    func dismiss() {
        safariViewController?.dismiss(animated: true) {
            WebViewPopup.popups.remove(self)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        WebViewPopup.popups.remove(self)
    }
    
    func safariViewController(_ controller: SFSafariViewController, activityItemsFor url: URL, title: String?) -> [UIActivity] {
        let activities = WebViewPopup.activities
        for activity in activities {
            activity.prepare(withActivityItems: [url])
        }
        return activities
    }
    
    static func open(_ url: URL, on vc: UIViewController) {
        WebViewPopup(url: url, root: vc).show()
    }
    
    static func openActivity(_ url: URL, on vc: UIViewController) {
        let activity = UIActivityViewController(activityItems: [url], applicationActivities: activities)
        vc.present(activity, animated: true, completion: nil)
    }
    
    static var activities: [UIActivity] {
        return [SVWebViewControllerActivitySafari(), SVWebViewControllerActivityChrome()]
    }
}

