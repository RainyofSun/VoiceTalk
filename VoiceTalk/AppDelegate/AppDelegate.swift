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
        // 设置语言
        LanguageTool.resetLanguage(languageName: LanguageTool.CHINESE);
        self.window = UIWindow.init(frame: UIScreen.main.bounds);
        self.window?.backgroundColor = UIColor.white;
        self.window?.rootViewController = VTMainViewController();
        self.window?.makeKeyAndVisible();
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default;
    }

}

