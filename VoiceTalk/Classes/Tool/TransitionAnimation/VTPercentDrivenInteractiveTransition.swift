//
//  VTPercentDrivenInteractiveTransition.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/30.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTPercentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition {
    
    public let UIPercentDrivenInteractiveTransitionStartNotification: String = "UIPercentDrivenInteractiveTransitionStartNotification"
    public let UIPercentDrivenInteractiveTransitionEndNotification: String = "UIPercentDrivenInteractiveTransitionEndNotification"
    public let UIPercentDrivenInteractiveTransitionInProgressNotification: String = "UIPercentDrivenInteractiveTransitionInProgressNotification"
    
    fileprivate(set) var completed: Bool = false
    fileprivate(set) var interactionInProgress: Bool = false
    fileprivate(set) var shouldCompleteTransition: Bool = false
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        Thread.current.threadDictionary.setObject(true, forKey: UIPercentDrivenInteractiveTransitionInProgressNotification as NSCopying)
        NotificationCenter.default.post(name: NSNotification.Name.init(UIPercentDrivenInteractiveTransitionStartNotification), object: self)
        super.startInteractiveTransition(transitionContext)
    }
    
    override func cancel() {
        self.completed = true
        self.interactionInProgress = false
        super.cancel()
        Thread.current.threadDictionary.removeObject(forKey: UIPercentDrivenInteractiveTransitionInProgressNotification)
        NotificationCenter.default.post(name: NSNotification.Name.init(UIPercentDrivenInteractiveTransitionEndNotification), object: self)
    }
    
    override func finish() {
        self.completed = true
        self.interactionInProgress = false
        super.finish()
        Thread.current.threadDictionary.removeObject(forKey: UIPercentDrivenInteractiveTransitionInProgressNotification)
        NotificationCenter.default.post(name: NSNotification.Name.init(UIPercentDrivenInteractiveTransitionEndNotification), object: self)
    }
}
