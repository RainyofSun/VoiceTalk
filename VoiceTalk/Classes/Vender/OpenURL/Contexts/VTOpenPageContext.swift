//
//  VTOpenPageContext.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/21.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTOpenPageContext: VTOpenURLContext {

    public weak var viewController: AnyObject?
    public var animated: Bool?
    
    override func start() {
        super.start()
        if self.invokeSource == .VTOpenURLContextInvokeSourceThirdAPP {
            self.animated = false
        } else {
            self.animated = (self.parameters["animated"] as? Bool) ?? true
        }
//        if VTGlobalStatusModel.shared.userInfoModel == nil || !VTGlobalStatusModel.shared.isLogin {
//            // 未登录状态不打开任何页面
//            let error: NSError = NSError.init(domain: VTOpenURLErrorDomain, code: VTOpenURLError.VTOpenURLNeedLoginError.rawValue, userInfo: [NSLocalizedDescriptionKey:"用户未登录"])
//            self.didFailedWithError(error: (error as Error))
//            return
//        }
        if (self.preset.parentControllerClass != nil) {
            var parentViewController: UIViewController? = self.manager!.existViewControllerWithClass(controllerClass: self.preset.controllerClass!)
            guard parentViewController != nil else {
                if let type = self.preset.parentControllerClass! as? VTBaseViewController.Type {
                    parentViewController = type.init(context: self)
                }
                self.openViewController(viewController: parentViewController, openStyle: VTOpenPageStyle.VTOpenPageStyleExist, animated: false)
                return
            }
            self.openViewController(viewController: parentViewController, openStyle: VTOpenPageStyle.VTOpenPageStyleExist, animated: false)
            return
        }
        var viewController: UIViewController?
        if self.openPageStyle == .VTOpenPageStyleExist {
            viewController = self.manager!.existViewControllerWithClass(controllerClass: self.preset.controllerClass!)
            if viewController != nil {
                let sel = Selector.init(("setParams:"))
                let response: Bool = viewController!.responds(to: sel)
                if response {
                    viewController!.perform(sel, with: self.parameters)
                }
            }
        } else {
            if let type = self.preset.controllerClass! as? VTBaseViewController.Type {
                viewController = type.init(context: self)
            }
        }
        guard viewController != nil else {
            let error: NSError = NSError.init(domain: VTOpenURLErrorDomain, code: VTOpenURLError.VTOpenURLNoControllerError.rawValue, userInfo: [NSLocalizedDescriptionKey:"没有找到对应的Controller"])
            self.didFailedWithError(error: (error as Error))
            return
        }
        guard viewController!.VTCanOpenNewPage() else {
            printLog("不能打开这个页面 --- %@",viewController!.description)
            return
        }
        self.viewController = viewController!
        self.openViewController(viewController: viewController, openStyle: self.openPageStyle ?? .VTOpenPageStylePush, animated: self.animated ?? true)
        self.didFinishWithResult(result: "已打开新的页面")
    }
    
    deinit {
        printLog("DELLOC : ",self.description)
    }
}
