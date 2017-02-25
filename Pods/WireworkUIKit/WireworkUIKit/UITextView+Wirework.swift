//
//  UITextView.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/08.
//
//

import UIKit
import Wirework

extension UITextView {
    public var wwText: (String?) -> Void {
        return { [weak self] in
            self?.text = $0
        }
    }
    
    public var wwAttributedText: (NSAttributedString?) -> Void {
        return { [weak self] in
            self?.attributedText = $0
        }
    }
    
    public var wwTextColor: (UIColor?) -> Void {
        return { [weak self] in
            self?.textColor = $0
        }
    }
    
    public var wwTextDidChange: Signal<Void> {
        return NotificationCenter.default.wwNotification(NSNotification.Name.UITextViewTextDidChange, object: self).voidSignal
    }
    
    public var wwTextDidEndEditing: Signal<Void> {
        return NotificationCenter.default.wwNotification(NSNotification.Name.UITextViewTextDidEndEditing, object: self).voidSignal
    }
    
    public var wwTextDidBeginEditing: Signal<Void> {
        return NotificationCenter.default.wwNotification(NSNotification.Name.UITextViewTextDidBeginEditing, object: self).voidSignal
    }
}
