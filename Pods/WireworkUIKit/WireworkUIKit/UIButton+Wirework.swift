//
//  UIButton.swift
//  Wirework
//
//  Created by Ryohei Ikegami on 2016/02/08.
//
//

import UIKit
import Wirework

public class ButtonState {
    private weak var _button: UIButton?
    private let _state: UIControlState
    
    init(button: UIButton, state: UIControlState) {
        _button = button
        _state = state
    }
    
    public var title: (String?) -> Void {
        return {
            self._button?.setTitle($0, for: self._state)
        }
    }
    
    public var attributedTitle: (NSAttributedString?) -> Void {
        return {
            self._button?.setAttributedTitle($0, for: self._state)
        }
    }
    
    public var titleColor: (UIColor?) -> Void {
        return {
            self._button?.setTitleColor($0, for: self._state)
        }
    }
    
    public var titleShadowColor: (UIColor?) -> Void {
        return {
            self._button?.setTitleShadowColor($0, for: self._state)
        }
    }
    
    public var image: (UIImage) -> Void {
        return {
            self._button?.setImage($0, for: self._state)
        }
    }
    
    public var backgroundImage: (UIImage) -> Void {
        return {
            self._button?.setBackgroundImage($0, for: self._state)
        }
    }
}

extension UIButton {
    public var wwTapped: Signal<Void> {
        return wwControlEvent(.touchUpInside).map { _ in }
    }
    
    public func wwState(_ state: UIControlState) -> ButtonState {
        return ButtonState(button: self, state: state)
    }
}
