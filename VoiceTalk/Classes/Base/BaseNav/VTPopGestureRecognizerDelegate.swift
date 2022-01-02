//
//  VTPopGestureRecognizerDelegate.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/28.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTPopGestureRecognizerDelegate: NSObject,UIGestureRecognizerDelegate {
    open weak var navigationController: UINavigationController?
    
}

extension VTPopGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIPanGestureRecognizer) -> Bool {
        guard self.navigationController == nil else {
            return false
        }
        // Ignore when no view controller is pushed into the navigation stack.
        if self.navigationController!.viewControllers.count <= 1 {
            return false
        }
        // Disable when the active view controller doesn't allow interactive pop.
        let topViewController:UIViewController = self.navigationController!.viewControllers.last!
        if topViewController.isKind(of: VTBaseViewController.self) {
            let topBaseViewController = topViewController as! VTBaseViewController
            if !topBaseViewController.addBackGesture! {
                return false
            }
            // Ignore pan gesture when the navigation controller is currently in transition.
            let _isTransitioning: Bool = self.navigationController!.value(forKey: "_isTransitioning") as! Bool
            if _isTransitioning {
                return false
            }
            // Prevent calling the handler when the gesture begins in an opposite direction.
            let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
            if translation.x <= 0 || abs(translation.x) < abs(translation.y) {
                return false
            }
            // 超出相应区域
            let location:CGPoint = gestureRecognizer.location(in: gestureRecognizer.view)
            if location.x >= topViewController.navigationItem.popEffectiveWidth {
                return false
            }
            
            /*
             VT:TODO
             //DAKeyboardControl
             if (topViewController.view.keyboardOpened) {
                 [topViewController.view hideKeyboard];
             }
             [topViewController.view endEditing:YES];
             return YES;
             */
            return true
        }
        return false
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.view?.isKind(of: UIScrollView.self) ?? false && gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            let panGesture: UIPanGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
            let trans: CGPoint = panGesture.translation(in: gestureRecognizer.view)
            let location:CGPoint = panGesture.location(in: gestureRecognizer.view)
            let topViewController:UIViewController = self.navigationController!.viewControllers.last!
            let result1:Bool = trans.x > 0 && abs(trans.x) > abs(trans.y)
            let result2:Bool = location.x < topViewController.navigationItem.popEffectiveWidth
            let result3:Bool = topViewController.navigationItem.edgePopEnable
            if result1 && result2 && result3 {
                otherGestureRecognizer.require(toFail: gestureRecognizer)
                return true
            }
        }
        return false
    }
}
