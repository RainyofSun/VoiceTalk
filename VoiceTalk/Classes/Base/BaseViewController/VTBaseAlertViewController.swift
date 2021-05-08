//
//  VTBaseAlertViewController.swift
//  VoiceTalk
//
//  Created by macos on 2021/5/6.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTBaseAlertViewController: UIViewController {

    var alertTitle : String?;
    var message : String?;
    var cancelButtonTitle : String?;
    var otherButtonTitle : String?;
    var imgName : String?;
    var cancelTitleColor : UIColor?;
    var completeBlock: ((_ buttonIndex:Int)->Void)?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    class func topViewController() -> UIViewController? {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController;
        if (rootViewController != nil) {
            return traverseFindTopViewController(controller: rootViewController!);
        }
        return nil;
    }
    
    class func showWithMessage(message:String) -> VTBaseAlertViewController {
        let alertViewController = VTBaseAlertViewController.init();
        alertViewController.message = message;
        alertViewController.showWithPresentVC(presentVC: VTBaseAlertViewController.topViewController()!, completeBlock: nil);
        return alertViewController;
    }
    
    class func initWithMessage(message:String,cancelButtonTitle:String,otherButtonTitle:String) -> VTBaseAlertViewController {
        let alertController = VTBaseAlertViewController.init();
        alertController.message = message;
        alertController.cancelButtonTitle = cancelButtonTitle;
        alertController.otherButtonTitle = otherButtonTitle;
        return alertController;
    }
    
    func dismissViewController(complete : (() -> Void)? = nil) {
        self.dismiss(animated: true, completion: complete);
    }
    
    private func showWithPresentVC(presentVC:UIViewController,completeBlock:((_ buttonIndex:Int)->Void)?) {
        self.modalPresentationStyle = UIModalPresentationStyle.custom;
        self.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
        if UIApplication.topMostController().isKind(of: VTBaseAlertViewController.self) {
            printLog("拦截二次Alert弹窗");
            return;
        }
        weak var weakSelf = self;
        presentVC.present(self, animated: true) {
            weakSelf?.completeBlock = completeBlock;
        };
    }
    
    private static func traverseFindTopViewController(controller:UIViewController) -> UIViewController {
        if controller.isKind(of: UITabBarController.self) {
            let tabController = controller as! UITabBarController;
            let selectedViewController = tabController.selectedViewController;
            return traverseFindTopViewController(controller: selectedViewController!);
        } else if (controller.isKind(of: UINavigationController.self)) {
            let navController = controller as! UINavigationController;
            return traverseFindTopViewController(controller: navController);
        } else {
            let presentViewController = controller.presentedViewController;
            if presentViewController != nil {
                return traverseFindTopViewController(controller: presentViewController!);
            }
        }
        return controller;
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
