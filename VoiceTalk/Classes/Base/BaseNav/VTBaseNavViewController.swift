//
//  VTBaseNavViewController.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/23.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTBaseNavViewController: UINavigationController, UINavigationControllerDelegate {

    open var alwaysHideNavigationBar: Bool = false {
        didSet {
            if alwaysHideNavigationBar {
                self.setNavigationBarHidden(true, animated: false)
            }
        }
    }
    open var animationViewController: UIViewController?
    override var hidesBarsOnSwipe: Bool {
        willSet {
            if UINavigationController.instancesRespond(to: #selector(setter: hidesBarsOnSwipe)) {
                self.hideBarGesture()?.isEnabled = hidesBarsOnSwipe
            }
        }
    }
    
    private var navigationAnimating: Bool = false
    private lazy var statusBarBackground: UIView = buildStatusBackgroundView()
    private var blockedViewController: UIViewController?
    private weak var vtPopGestureRecognizerDelegate: VTPopGestureRecognizerDelegate?
    private lazy var vtNavigationInteractiveTransition: VTNavigationInteractiveTransition = {
        return VTNavigationInteractiveTransition.init(navigationController: self)
    }()
    private lazy var popGestureRecognizer: UIPanGestureRecognizer = {
        let tempGesture = UIPanGestureRecognizer.init()
        tempGesture.maximumNumberOfTouches = 1
        return tempGesture
    }()
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        if above_ios_13 {
            self.modalPresentationStyle = .fullScreen
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        if above_ios_13 {
            self.modalPresentationStyle = .fullScreen
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if above_ios_13 {
            self.modalPresentationStyle = .fullScreen
        }
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setNavigationBarItem()
        // Do any additional setup after loading the view.
    }

    override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        super.setNavigationBarHidden(hidden, animated: animated)
        let _isTransitioning: Bool = self.navigationController?.value(forKey: "_isTransitioning") as! Bool
        if _isTransitioning {
           return
        }
        let hideNavigationBar: Bool = self.topViewController?.navigationItem.hideNavigationBar ?? true
        let showStatusbarBackground: Bool = self.topViewController?.navigationItem.showStatusbarBackground ?? true
        if (hidden && !hideNavigationBar && !self.alwaysHideNavigationBar) || showStatusbarBackground {
            self.setStatusBarBackgroundHidden(hidden: false)
        } else {
            self.setStatusBarBackgroundHidden(hidden: true)
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let hasPangesture: Bool =  self.interactivePopGestureRecognizer?.view?.gestureRecognizers?.contains(self.popGestureRecognizer) ?? false
        if !hasPangesture {
            let gesture = self.interactivePopGestureRecognizer
            gesture?.isEnabled = false
            let gestureView = gesture?.view
            self.popGestureRecognizer.delegate = self.buildPopGestureDeleagte()
            gestureView?.addGestureRecognizer(self.popGestureRecognizer)
            self.popGestureRecognizer.addTarget(self.vtNavigationInteractiveTransition, action: #selector(handleControllerPop(gesture:)))
        }
        
        if self.children.contains(viewController) {
            assert(false,"Pushing the same view controller instance more than once is not supported")
        } else {
            super.pushViewController(viewController, animated: animated)
        }
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let topViewController = self.topViewController as? VTBaseViewController
        guard topViewController != nil else {
            return nil
        }
        if animated {
            self.animationViewController = topViewController
        }
        return super.popViewController(animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        guard self.animationViewController == nil else {
            return nil
        }
        if animated {
            self.animationViewController = self.viewControllers.first
        }
        return super.popToRootViewController(animated: animated)
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        guard self.animationViewController == nil else {
            return nil
        }
        if animated {
            self.animationViewController = viewController
        }
        return super.popToViewController(viewController, animated: animated)
    }
}

// MARK - UINavigationControllerDelegate
extension VTBaseNavViewController {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.animationViewController = nil
        if self.blockedViewController != nil {
            let tempController = self.blockedViewController
            self.pushViewController(tempController!, animated: false)
            self.blockedViewController = nil
        }
        self.hidesBarsOnSwipe = viewController.navigationItem.hideNavigationBarOnSwipe ?? true
        let hideStatusBar: Bool = viewController.navigationItem.showStatusbarBackground ?? true
        self.setStatusBarBackgroundHidden(hidden: !hideStatusBar)
        navigationController.view.addSubview(self.statusBarBackground)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if navigationController == self && self.alwaysHideNavigationBar {
            navigationController.setNavigationBarHidden(true, animated: animated)
        } else if viewController.navigationItem.hideNavigationBar != self.navigationBar.isHidden {
            let hideNavBar = viewController.navigationItem.hideNavigationBar ?? false
            navigationController.setNavigationBarHidden(hideNavBar, animated: animated)
        }
        if self.animationViewController != nil {
            let fromVC: UIViewController?
            let toVC: UIViewController = viewController
            if self.animationViewController == viewController {
                // push
                let index: Int = self.viewControllers.firstIndex(where: {$0==viewController}) ?? 0
                if index > 0 {
                    fromVC = self.viewControllers[index - 1]
                } else {
                    fromVC = viewController
                }
            } else {
                // pop
                fromVC = self.animationViewController
            }
            self.statusBarBackground.isHidden = false
            let toVCShowStatusBar = toVC.navigationItem.showStatusbarBackground ?? false
            let fromVCShowStatusBar = fromVC!.navigationItem.showStatusbarBackground ?? false
            if toVCShowStatusBar && !fromVCShowStatusBar {
                navigationController.view.addSubview(self.statusBarBackground)
            } else if toVCShowStatusBar && !fromVCShowStatusBar {
                toVC.view.addSubview(self.statusBarBackground)
            } else if !toVCShowStatusBar && fromVCShowStatusBar {
                fromVC?.view.addSubview(self.statusBarBackground)
            } else {
                self.statusBarBackground.isHidden = true
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push && toVC.pushAnimationController != nil {
            toVC.pushAnimationController!.actionType = .VTViewControllerActionPush
            return toVC.pushAnimationController
        } else if operation == .pop && fromVC.popAnimationController != nil {
            return fromVC.popAnimationController
        }
        if operation == .pop {
            let popAnimation: VTPopAnimation = VTPopAnimation.init()
            popAnimation.fromNavBg = navigationController.navigationBar.backgroundImage(for: .default)
            popAnimation.fromStatusHiden = UIApplication.shared.isStatusBarHidden
            if self.vtNavigationInteractiveTransition.interactivePopTransition != nil {
                popAnimation.lineAnimation = true
            } else {
                popAnimation.lineAnimation = false
            }
            return popAnimation
        } else if operation == .push {
            let pushAnimation = VTPushAnimation.init()
            pushAnimation.fromNavBg = navigationController.navigationBar.backgroundImage(for: .default)
            pushAnimation.fromStatusHiden = UIApplication.shared.isStatusBarHidden
            return pushAnimation
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let tempAnimator = animationController as? VTViewControllerAnimationController else {
            return nil
        }
        if tempAnimator.interactiveTransitioningController != nil {
            if tempAnimator.interactiveTransitioningController!.interactionInProgress {
                return tempAnimator.interactiveTransitioningController!
            }
        }
        if animationController.isKind(of: VTPopAnimation.self) || animationController.isKind(of: VTPushAnimation.self) {
            return self.vtNavigationInteractiveTransition.interactivePopTransition
        }
        return nil
    }
}

extension VTBaseNavViewController {
    func setNavigationBarItem() {
        UITabBarItem.appearance().setTitleTextAttributes([.font:appFont(fontSize: 9),.foregroundColor:VTColor(hexString: "ffffff", alpha: 0.5)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.font:appFont(fontSize: 9),.foregroundColor:VTGrayColor], for: .disabled)
        UITabBarItem.appearance().setTitleTextAttributes([.font:appFont(fontSize: 9),.foregroundColor:VTRedColor], for: .highlighted)
        self.navigationBar.shadowImage = UIImage.imageWithColor(VTClearColor)
        self.navigationBar.backgroundColor = VTClearColor
        self.navigationBar.tintColor = VTClearColor
    }
    
    func buildStatusBackgroundView() -> UIView {
        let tempView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.vt_width, height: kStatusBarHeight))
        tempView.backgroundColor = VTWhiteColor
        tempView.autoresizingMask = .flexibleWidth
        tempView.isUserInteractionEnabled = false
        return tempView
    }
    
    func setStatusBarBackgroundHidden(hidden: Bool) {
        if !hidden {
            self.view.bringSubviewToFront(self.navigationBar)
        }
        self.statusBarBackground.isHidden = hidden
    }
    
    func hideBarGesture() -> UIGestureRecognizer? {
        if self.responds(to: #selector(setter: hidesBarsOnTap)) {
            let gesture = self.value(forKey: "__barSwipeHideGesture")
            return gesture as? UIGestureRecognizer
        }
        return nil
    }
    
    func buildPopGestureDeleagte() -> VTPopGestureRecognizerDelegate {
        guard self.vtPopGestureRecognizerDelegate != nil else {
            let tempDelegate = VTPopGestureRecognizerDelegate.init()
            tempDelegate.navigationController = self
            self.vtPopGestureRecognizerDelegate = tempDelegate
            return tempDelegate
        }
        return self.vtPopGestureRecognizerDelegate!
    }
}

// MARK - Action
extension VTBaseNavViewController {
    @objc func handleControllerPop(gesture: UIPanGestureRecognizer) {
        
    }
}
