//
//  UITextField.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/08.
//
//

import UIKit
import Wirework

extension UITextField {
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
    
    public var wwTextChanged: Signal<String?> {
        return wwControlEvent(.ValueChanged).map { [weak self] _ in self?.text }
    }
    
    public var wwAttributedTextChanged: Signal<NSAttributedString?> {
        return wwControlEvent(.ValueChanged).map { [weak self] _ in self?.attributedText }
    }
    
    public var wwTextColor: (UIColor?) -> Void {
        return { [weak self] in
            self?.textColor = $0
        }
    }
}