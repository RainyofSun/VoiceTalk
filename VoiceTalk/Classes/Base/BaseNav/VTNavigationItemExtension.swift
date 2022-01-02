//
//  VTNavigationItemExtension.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/28.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

extension UINavigationItem {
    private struct AssociatedKey {
        static var showStatusbarBackgroundKey: String = "showStatusbarBackgroundKey"
        static var hideNavigationBarKey:String = "hideNavigationBar"
        static var hideNavigationBarOnSwipeKey:String = "hideNavigationBarOnSwipeKey"
        static var transItemKey:String = "transItemKey"
        static var transSubViewKey:String = "transSubViewKey"
        static var popEffectiveWidthKey: String = "popEffectiveWidthKey"
        static var edgePopEnableKey: String = "edgePopEnableKey"
    }
    
    open var showStatusbarBackground: Bool? {
        set {
            setAssociated(value: newValue, associatedKey: &AssociatedKey.showStatusbarBackgroundKey)
        }
        get {
            return getAssociated(associatedKey: &AssociatedKey.showStatusbarBackgroundKey) as? Bool
        }
    }
    
    open var hideNavigationBar: Bool? {
        set {
            setAssociated(value: newValue, associatedKey: &AssociatedKey.hideNavigationBarKey)
        }
        get {
            return getAssociated(associatedKey: &AssociatedKey.hideNavigationBarKey) as? Bool
        }
    }
    
    open var hideNavigationBarOnSwipe: Bool? {
        set {
            setAssociated(value: newValue, associatedKey: &AssociatedKey.hideNavigationBarOnSwipeKey)
        }
        get {
            return getAssociated(associatedKey: &AssociatedKey.hideNavigationBarOnSwipeKey) as? Bool
        }
    }
    
    open var transItem: UINavigationItem? {
        set {
            setAssociated(value: newValue, associatedKey: &AssociatedKey.transItemKey)
        }
        get {
            return getAssociated(associatedKey: &AssociatedKey.transItemKey) as? UINavigationItem
        }
    }
    
    open var transSubView: UIView? {
        set {
            setAssociated(value: newValue, associatedKey: &AssociatedKey.transSubViewKey)
        }
        get {
            return getAssociated(associatedKey: &AssociatedKey.transSubViewKey) as? UIView
        }
    }
    
    open var popEffectiveWidth: CGFloat {
        set {
            setAssociated(value: newValue, associatedKey: &AssociatedKey.popEffectiveWidthKey)
        }
        get {
            return getAssociated(associatedKey: &AssociatedKey.popEffectiveWidthKey) as? CGFloat ?? screen_width
        }
    }
    
    open var edgePopEnable: Bool {
        set {
            setAssociated(value: newValue, associatedKey: &AssociatedKey.edgePopEnableKey)
        }
        get {
            return getAssociated(associatedKey: &AssociatedKey.edgePopEnableKey) as? Bool ?? true
        }
    }
}
