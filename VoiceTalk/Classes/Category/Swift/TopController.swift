//
//  TopController.swift
//  VoiceTalk
//
//  Created by macos on 2021/5/6.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

extension UIApplication {
    class func topMostController(baseVC :UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController {
        if let nav = baseVC as? UINavigationController {
            return topMostController(baseVC: nav.topViewController);
        } else if let tab = baseVC as? UITabBarController, let selected = tab.selectedViewController {
            return topMostController(baseVC: selected);
        } else if let presented = baseVC?.presentedViewController {
            return topMostController(baseVC: presented);
        }
        return baseVC!;
    }
}
