//
//  VTPushAnimation.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/1.
//  Copyright © 2022 macos. All rights reserved.
//

import UIKit

class VTPushAnimation: NSObject {

    open var fromNavBg: UIImage? = nil
    open var toNavBg: UIImage? = nil
    open var fromStatusHiden: Bool = false
    open var toStatusHiden: Bool = false
    open var lineAnimation: Bool? = true
    
    private var toTransBar: UINavigationBar? = nil
    private var fromTransBar: UINavigationBar? = nil
    private var navigationController: UINavigationController? = nil
    private var tabBar: UIImageView? = nil
    
    deinit {
        printLog("DELLOC ",self.description)
    }
    
    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.28
    }
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        self.toStatusHiden = UIApplication.shared.isStatusBarHidden
        
        if fromViewController.edgesForExtendedLayout == [] || !(fromViewController.navigationController?.navigationBar.isTranslucent)! {
            if fromViewController.navigationItem.hideNavigationBar ?? false {
                fromViewController.view.vt_top = 0
                fromViewController.view.vt_height = screen_height
            } else {
                let tempHeight: CGFloat = self.fromStatusHiden ? 44 : kNavBarAndStatusBarHeight
                fromViewController.view.vt_top = tempHeight
                fromViewController.view.vt_height = screen_height - tempHeight
            }
        }
        if toViewController.edgesForExtendedLayout == [] || !(toViewController.navigationController?.navigationBar.isTranslucent)! {
            if toViewController.navigationItem.hideNavigationBar ?? false {
                toViewController.view.vt_top = 0
                toViewController.view.vt_height = screen_height
            } else {
                let tempHeight = self.toStatusHiden ? 44 : kNavBarAndStatusBarHeight
                toViewController.view.vt_top = tempHeight
                toViewController.view.vt_height = screen_height - tempHeight
            }
        }
        let containerView: UIView = transitionContext.containerView
        containerView.insertSubview(toViewController.view, aboveSubview: fromViewController.view)
        let toViewControllerTrans = toViewController.view.transform
        toViewControllerTrans.translatedBy(x: screen_width, y: 0)
        toViewController.view.transform = toViewControllerTrans
        fromViewController.view.transform = CGAffineTransform.identity
        
        self.navigationController = fromViewController.navigationController
        self.navigationController?.navigationBar.alpha = 0.001
        
        if self.toNavBg == nil {
            self.toNavBg = self.navigationController!.navigationBar.backgroundImage(for: .default)
        }
        if self.toTransBar == nil {
            self.toTransBar = VTAnimationNavigationBar.init(frame: CGRect.init(x: 0, y: 0, width: screen_width, height: kNavBarAndStatusBarHeight))
            if let subView = toViewController.navigationItem.transSubView {
                let imgView = UIImageView.init(image: subView.imageFromView())
                imgView.frame = subView.frame
                self.toTransBar!.addSubview(imgView)
            }
            if self.toNavBg != nil {
                self.toTransBar!.setBackgroundImage(self.toNavBg, for: .default)
                self.toTransBar!.isTranslucent = true
            } else {
                self.toTransBar!.setBackgroundImage(UIImage.imageWithColor(VTWhiteColor), for: .default)
                self.toTransBar!.isTranslucent = false
            }
            self.toTransBar!.isHidden = toViewController.navigationItem.hideNavigationBar ?? false
            self.toTransBar!.shadowImage = UIImage.init()
            self.toTransBar!.autoresizingMask = [.flexibleTopMargin,.flexibleLeftMargin]
            
            var tempData: Data? = nil
            var item: UINavigationItem? = nil
            do {
                tempData = NSKeyedArchiver.archivedData(withRootObject: toViewController.navigationItem)
                if tempData != nil {
                    item = NSKeyedUnarchiver.unarchiveObject(with: tempData!) as? UINavigationItem
                }
            }
            if item != nil {
                self.toTransBar?.setItems([item!], animated: false)
                toViewController.navigationItem.transItem = item!
            }
        }
        if self.fromTransBar == nil {
            self.fromTransBar = VTAnimationNavigationBar.init(frame: CGRect.init(x: 0, y: 0, width: screen_width, height: kNavBarAndStatusBarHeight))
            if let subView = fromViewController.navigationItem.transSubView {
                let imgView: UIImageView = UIImageView.init(image: subView.imageFromView())
                imgView.frame = subView.frame
                self.fromTransBar!.addSubview(imgView)
            }
            if self.fromNavBg != nil {
                self.fromTransBar!.setBackgroundImage(self.fromNavBg, for: .default)
                self.fromTransBar?.isTranslucent = true
            } else {
                self.fromTransBar!.setBackgroundImage(UIImage.imageWithColor(VTWhiteColor), for: .default)
                self.fromTransBar!.isTranslucent = false
            }
            self.fromTransBar!.isHidden = fromViewController.navigationItem.hideNavigationBar ?? false
            self.fromTransBar!.shadowImage = UIImage.init()
            self.fromTransBar!.autoresizingMask = [.flexibleTopMargin,.flexibleLeftMargin]
            
            var tempData: Data? = nil
            var item: UINavigationItem? = nil
            do {
                tempData = NSKeyedArchiver.archivedData(withRootObject: fromViewController.navigationItem)
                if tempData != nil {
                    item = NSKeyedUnarchiver.unarchiveObject(with: tempData!) as? UINavigationItem
                }
            }
            if item != nil {
                self.fromTransBar?.setItems([item!], animated: false)
                fromViewController.navigationItem.transItem = item!
            }
        }
        
        if self.fromStatusHiden {
            self.fromTransBar!.vt_top = -screen_height
        }
        if self.toStatusHiden {
            self.toTransBar!.vt_top = -screen_height
        }
        containerView.insertSubview(self.fromTransBar!, belowSubview: toViewController.view)
        containerView.insertSubview(self.toTransBar!, aboveSubview: toViewController.view)
        let toViewTransFrom = self.toTransBar!.transform
        toViewTransFrom.translatedBy(x: screen_width, y: 0)
        self.toTransBar!.transform = toViewTransFrom
        self.fromTransBar!.transform = CGAffineTransform.identity
        
        if !fromViewController.hidesBottomBarWhenPushed {
            self.tabBar = UIImageView.init(frame: CGRect.init(x: 0, y: fromViewController.view.vt_height - (kTabBarHeight + 15), width: fromViewController.view.vt_width, height: kTabBarHeight + 15))
            let img: UIImage = (self.navigationController?.tabBarController?.tabBar.imageFromViewInRect(rect: self.tabBar!.bounds))!
            self.tabBar!.image = img
            self.tabBar!.autoresizingMask = [.flexibleBottomMargin]
            fromViewController.view.addSubview(self.tabBar!)
            self.navigationController?.tabBarController?.tabBar.isHidden = true
        }
        
        let duration: TimeInterval = self.transitionDuration(using: transitionContext)
        let animationOption: UIView.AnimationOptions = self.lineAnimation! ? UIView.AnimationOptions.curveLinear : UIView.AnimationOptions.curveEaseOut
        UIView.animate(withDuration: duration, delay: 0.0, options: animationOption) {
            let fromViewTransFrom = fromViewController.view.transform
            fromViewTransFrom.translatedBy(x: -screen_width, y: 0)
            fromViewController.view.transform = fromViewTransFrom
            toViewController.view.transform = CGAffineTransform.identity
            let fromTransBar = self.fromTransBar!.transform
            fromTransBar.translatedBy(x: -screen_width * 0.3, y: 0)
            self.fromTransBar!.transform = fromTransBar
            self.toTransBar!.transform = CGAffineTransform.identity
        } completion: { completed in
            toViewController.view.transform = CGAffineTransform.identity
            fromViewController.view.transform = CGAffineTransform.identity
            self.toTransBar!.transform = CGAffineTransform.identity
            self.fromTransBar!.transform = CGAffineTransform.identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            self.fromTransBar!.removeFromSuperview()
            self.fromTransBar = nil
            self.toTransBar!.removeFromSuperview()
            self.toTransBar = nil
            self.navigationController?.navigationBar.alpha = 1
            if self.tabBar != nil {
                self.navigationController?.navigationBar.isHidden = self.navigationController?.topViewController?.hidesBottomBarWhenPushed ?? false
                self.tabBar!.removeFromSuperview()
                self.tabBar = nil
            }
        }
    }
}
