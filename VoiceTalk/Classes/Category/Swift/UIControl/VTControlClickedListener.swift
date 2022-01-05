//
//  VTControlClickedListener.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/4.
//  Copyright © 2022 macos. All rights reserved.
//

import UIKit

typealias UIControlClickedListener = (UIControl) -> ()

extension UIControl {
    
    private struct ControlAssociatedKeys {
        static var clickedListenerKey = "clickedListenerKey"
    }
    
    private var clickedListener: UIControlClickedListener? {
        set {
            setAssociated(value: newValue, associatedKey: &ControlAssociatedKeys.clickedListenerKey)
        }
        get {
            return getAssociated(associatedKey: &ControlAssociatedKeys.clickedListenerKey) as? UIControlClickedListener
        }
    }

    func setOnClickedListener(listener: @escaping UIControlClickedListener) {
        clickedListener = listener
        addTarget(self, action: #selector(onButtonClicked), for: .touchUpInside)
    }

    @objc func onButtonClicked() {
        if let listener = self.clickedListener {
            listener(self)
        }
    }
}
