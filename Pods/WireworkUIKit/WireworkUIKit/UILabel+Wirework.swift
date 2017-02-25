//
//  UILabel.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/06.
//
//

import Foundation
import WireworkFoundation

extension UILabel {
    
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
    
    public var wwEnabled: (Bool) -> Void {
        return { [weak self] in
            self?.isEnabled = $0
        }
    }
}
