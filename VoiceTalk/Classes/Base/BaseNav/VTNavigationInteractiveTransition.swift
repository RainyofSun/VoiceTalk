//
//  VTNavigationInteractiveTransition.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/30.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTNavigationInteractiveTransition: NSObject {

    open var interactivePopTransition: VTPercentDrivenInteractiveTransition?
    private weak var navVC: UINavigationController?
    
    init(navigationController: UINavigationController) {
        super.init()
        self.navVC = navigationController
    }
    
    deinit {
        removeSystemNotification()
        printLog("DELLOC:",self.description)
    }
    
    public func handleControllerPop(recognizer: UIPanGestureRecognizer) {
        controllerPop(recognizer: recognizer)
    }
}

extension VTNavigationInteractiveTransition {
    
    func removeSystemNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func controllerPop(recognizer: UIPanGestureRecognizer) {
        var progress: CGFloat = recognizer.translation(in: recognizer.view).x / recognizer.view!.vt_width
        progress = min(1.0, max(0.0, progress))
        if recognizer.state == .began {
            self.interactivePopTransition = VTPercentDrivenInteractiveTransition.init()
            self.navVC?.popViewController(animated: true)
        } else if recognizer.state == .changed {
            self.interactivePopTransition!.update(progress)
        } else if recognizer.state == .ended || recognizer.state == .cancelled {
            let velocity: CGPoint = recognizer.velocity(in: recognizer.view)
            if progress >= 0.5 || velocity.x > 800 {
                self.interactivePopTransition!.finish()
            } else {
                self.interactivePopTransition!.cancel()
            }
            self.interactivePopTransition = nil
        }
    }
}
