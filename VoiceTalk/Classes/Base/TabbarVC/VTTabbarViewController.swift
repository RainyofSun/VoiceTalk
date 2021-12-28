//
//  VTTabbarViewController.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/19.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTTabbarViewController: UITabBarController, VTTabBarDelegate, UITabBarControllerDelegate {
    
    private var customTabbar: VTTabBar?
    override var selectedIndex: Int {
        didSet {
            self.customTabbar!.selectedTabBarItem(selectedIndex: selectedIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        commitInitView();
        addAllChildsController();
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var originalFrame = self.tabBar.frame
        originalFrame.size.height = self.customTabbar!.composeTop + kTabBarHeight
        originalFrame.origin.y = self.view.vt_height - originalFrame.size.height
        self.tabBar.frame = originalFrame
        self.customTabbar!.frame = self.tabBar.bounds
        self.hideIOS13BlackLine()
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        self.tabBar.subviews.forEach { tempView in
            if tempView.isKind(of: UIControl.self) {
                tempView.isHidden = true
            }
        }
        self.tabBar.bringSubviewToFront(self.customTabbar!)
    }
}

// MARK - UITabBarControllerDelegate
extension VTTabbarViewController {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // 登录拦截
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let selectedIndex = self.viewControllers!.firstIndex(where: {$0 == viewController})!
        self.customTabbar!.selectedTabBarItem(selectedIndex: selectedIndex)
    }
}

// MARK - VTTabBarDelegate
extension VTTabbarViewController {
    func tabbarWillSelectedItem(tabbar: VTTabBar, selectedIndex: Int) -> Bool {
        return true
    }
    
    func tabbarDidSelectedItem(tabbar: VTTabBar, selectedIndex: Int) {
        self.selectedIndex = selectedIndex
    }
    
    func tabbarLongPressedComposeItem(tabbar: VTTabBar, selectedIndex: Int) {
        
    }
}

extension VTTabbarViewController {
    func setupUI() {
        self.tabBar.vt_height = kTabBarHeight
        self.tabBar.vt_bottom = screen_height
        self.customTabbar = VTTabBar.init(frame: self.tabBar.bounds)
        self.customTabbar?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        self.customTabbar?.tabbarDelegate = self
        self.tabBar.shadowImage = UIImage.imageWithColor(VTClearColor)
        self.tabBar.backgroundImage = UIImage.imageWithColor(VTClearColor)
        self.tabBar.backgroundColor = VTClearColor;
        self.tabBar.tintColor = VTClearColor
        self.tabBar.barTintColor = VTClearColor
        self.tabBar.addSubview(self.customTabbar!)
        self.tabBar.bringSubviewToFront(self.customTabbar!)
        self.delegate = self
        self.authorization()
        vt_dispatch_after_block(time: .now() + 10) {
            self.hideIOS13BlackLine()
        }
    }
    
    func authorization() {
        if UIApplication.shared.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:))) || UIApplication.shared.isRegisteredForRemoteNotifications {
            // 注册 APNS
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) { granted, error in
                    vt_dispatch_main_block {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            } else {
                if UIApplication.shared.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:))) {
                    UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings.init(types: [.sound,.badge,.alert], categories: nil))
                    vt_dispatch_main_block {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
    }
    
    func hideIOS13BlackLine() {
        if #available(iOS 13.0, *) {
            let tabbarApperaance = self.tabBar.standardAppearance.copy()
            tabbarApperaance.backgroundImage = UIImage.imageWithColor(VTClearColor)
            tabbarApperaance.shadowImage = UIImage.imageWithColor(VTClearColor)
            tabbarApperaance.configureWithTransparentBackground()
            self.tabBar.standardAppearance = tabbarApperaance
        } else {
            // Fallback on earlier versions
        }
    }
    
    func commitInitView() {
        view.backgroundColor = UIColor.clear;
        tabBar.backgroundImage = UIImage.imageWithColor(VTClearColor)
        tabBar.shadowImage = UIImage.imageWithColor(VTClearColor)
        tabBar.isTranslucent = false;
        tabBar.tintColor = UIColor.white;
        tabBar.barTintColor = UIColor.white;
        tabBar.barStyle = .blackOpaque;
        tabBarController?.tabBar.isTranslucent = false;
        self.view.translatesAutoresizingMaskIntoConstraints = false;
        self.hidesBottomBarWhenPushed = true
    }
    
    func addAllChildsController() {
        let viewControllers = [addChildVC(childVC: VTHomePageViewController()),
                               addChildVC(childVC: VTZoneDynamicPageViewController()),
                               addChildVC(childVC: VTBaseViewController()),
                               addChildVC(childVC: VTChatPageViewController()),
                               addChildVC(childVC: VTMinePageViewController())]
        let titles = [VTStr(str: "首页"),VTStr(str: "动态"),VTStr(str: "聊天"),VTStr(str: "我的")]
        let normalImgs = ["navigation_tab_home_nor_icon","navigation_tab_camera_nor_icon",
                          "navigation_tab_chat_nor_icon","navigation_tab_me_nor_icon"]
        let selectedImgs = ["navigation_tab_home_selected_icon","navigation_tab_camera_selected_icon","navigation_tab_chat_selected_icon","navigation_tab_me_selected_icon"]
        
        self.customTabbar!.buildTabBarItems(titles: titles, normalImgs: normalImgs, selectedImgs: selectedImgs)
        self.viewControllers = viewControllers
    }
    
    func addChildVC(childVC:VTBaseViewController) ->VTBaseNavViewController {
        let navVC = VTBaseNavViewController.init(rootViewController: childVC);
        navVC.navigationBar.isHidden = (title == nil || title?.count == 0);
        return navVC
    }
}
