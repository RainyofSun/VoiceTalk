//
//  AppDelegate.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/12.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initRootVC();
        return true
    }
    
    func initRootVC() {
        self.window = UIWindow.init(frame: UIScreen.main.bounds);
        self.window?.backgroundColor = UIColor.white;
        self.window?.makeKeyAndVisible();
        self.window?.rootViewController = VTMainViewController();
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default;
    }

}

