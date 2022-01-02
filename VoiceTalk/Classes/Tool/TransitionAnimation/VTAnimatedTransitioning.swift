//
//  VTAnimatedTransitioning.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/1.
//  Copyright © 2022 macos. All rights reserved.
//

import UIKit
import StoreKit

enum VTViewControllerActionType: Int {
    case VTViewControllerActionPresent = 0
    case VTViewControllerActionDismiss
    case VTViewControllerActionPush
    case VTViewControllerActionPop
    case VTViewControllerActionTabSelect
}

protocol VTViewControllerAnimationController: UIViewControllerAnimatedTransitioning {
    var actionType: VTViewControllerActionType { get set }
    var interactiveTransitioningController: VTPercentDrivenInteractiveTransition? { get set }
}

extension UIViewController: UIViewControllerTransitioningDelegate {
    private struct UIViewControllerAssociatedKey {
        static var presentAnimationControllerKey: String = "presentAnimationControllerKey"
        static var pushAnimationControllerKey: String = "pushAnimationControllerKey"
        static var popAnimationControllerKey: String = "popAnimationControllerKey"
    }
    
    weak var presentAnimationController: VTViewControllerAnimationController? {
        set {
            setAssociated(value: newValue, associatedKey: &UIViewControllerAssociatedKey.presentAnimationControllerKey)
        }
        get {
            return getAssociated(associatedKey: &UIViewControllerAssociatedKey.presentAnimationControllerKey) as? VTViewControllerAnimationController
        }
    }
    
    weak var pushAnimationController: VTViewControllerAnimationController? {
        set {
            setAssociated(value: newValue, associatedKey: &UIViewControllerAssociatedKey.pushAnimationControllerKey)
        }
        get {
            return getAssociated(associatedKey: &UIViewControllerAssociatedKey.pushAnimationControllerKey) as? VTViewControllerAnimationController
        }
    }
    
    weak var popAnimationController: VTViewControllerAnimationController? {
        set {
            setAssociated(value: newValue, associatedKey: &UIViewControllerAssociatedKey.popAnimationControllerKey)
        }
        get {
            return getAssociated(associatedKey: &UIViewControllerAssociatedKey.popAnimationControllerKey) as? VTViewControllerAnimationController
        }
    }
    
    func presentViewController(viewControllerToPresent: UIViewController, animationController:VTViewControllerAnimationController,completion:@escaping ()->(Void)) {
        if viewControllerToPresent.transitioningDelegate == nil {
            viewControllerToPresent.transitioningDelegate = viewControllerToPresent
            viewControllerToPresent.presentAnimationController = animationController
        }
        self.present(viewControllerToPresent, animated: true, completion: completion)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var animationController = presented.presentAnimationController
        if animationController == nil && presented.isKind(of: UINavigationController.self) {
            let tempNav: UINavigationController = presented as! UINavigationController
            animationController = tempNav.topViewController?.presentAnimationController
        }
        if animationController != nil {
            animationController!.actionType = .VTViewControllerActionPresent
            return animationController
        }
        return nil
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var animationController = dismissed.presentAnimationController
        if animationController == nil && dismissed.isKind(of: UINavigationController.self) {
            let tempNav: UINavigationController = dismissed as! UINavigationController
            animationController = tempNav.topViewController?.presentAnimationController
        }
        if animationController != nil {
            animationController!.actionType = .VTViewControllerActionDismiss
            return animationController
        }
        return nil
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let tempAnimator = animator as? VTViewControllerAnimationController else {
            return nil
        }
        if tempAnimator.interactiveTransitioningController != nil {
            if tempAnimator.interactiveTransitioningController!.interactionInProgress {
                return tempAnimator.interactiveTransitioningController!
            }
        }
        return nil
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let tempAnimator = animator as? VTViewControllerAnimationController else { return nil }
        if tempAnimator.interactiveTransitioningController != nil {
            if tempAnimator.interactiveTransitioningController!.interactionInProgress {
                return tempAnimator.interactiveTransitioningController!
            }
        }
        return nil
    }
}

extension NSObject: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        transitionContext.completeTransition(true)
    }
}
