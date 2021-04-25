//
//  VTTabbarViewController.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/19.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTTabbarViewController: RAMAnimatedTabBarController {

    override func viewDidLoad() {
        addAllChildsController();
        super.viewDidLoad()
        commitInitView();
        // Do any additional setup after loading the view.
    }
    
    private func commitInitView() {
        view.backgroundColor = UIColor.clear;
        tabBar.isTranslucent = false;
        tabBar.tintColor = UIColor.white;
        tabBar.barTintColor = UIColor.white;
        tabBar.barStyle = .blackOpaque;
        tabBarController?.tabBar.isTranslucent = false;
        self.view.translatesAutoresizingMaskIntoConstraints = false;
    }
    
    private func addAllChildsController() {
        // 首页
        addChildVC(childVC: VTHomePageViewController(), itemTitle: "首页", title: nil, imageNormal: "tab_home", imageSelected: "tab_home_selected",itemAnimation: RAMRotationAnimation());
        // 动态
        addChildVC(childVC: VTZoneDynamicPageViewController(), itemTitle: "动态", title: nil, imageNormal: "tab_moment", imageSelected: "tab_moment_selected",itemAnimation: RAMBounceAnimation());
        // 聊天
        addChildVC(childVC: VTChatPageViewController(), itemTitle: "聊天", title: nil, imageNormal: "tab_chat", imageSelected: "tab_chat_selected",itemAnimation: RAMBounceAnimation());
        // 我的
        addChildVC(childVC: VTMinePageViewController(), itemTitle: "我的", title: nil, imageNormal: "tab_mine", imageSelected: "tab_mine_selected",itemAnimation: RAMBounceAnimation());
    }
    
    private func addChildVC(childVC:VTBaseViewController, itemTitle: String, title :String?, imageNormal:String, imageSelected:String, itemAnimation:RAMItemAnimation) {
        let navVC = VTBaseNavViewController.init(rootViewController: childVC);
        navVC.navigationBar.isHidden = (title == nil || title?.count == 0);
        let normalFilePath = SVGResourcePath(fileName: "TabBar", imgName: imageNormal);
        let selectedFilePath = SVGResourcePath(fileName: "TabBar", imgName: imageSelected);
        let item = RAMAnimatedTabBarItem(title: itemTitle, image: UIImage.svgImage(withContentFile: normalFilePath), selectedImage: UIImage.svgImage(withContentFile: selectedFilePath));
        item.textColor = tabbarNormalColor;
        item.textFontSize = 14;
        item.iconColor = tabbarNormalColor;
        item.animation = itemAnimation;
        item.imageInsets = UIEdgeInsets.init(top: 6, left: 0, bottom: -6, right: 0);
        item.animation.textSelectedColor = tabbarSelectedColor;
        item.animation.iconSelectedColor = tabbarSelectedColor;
        addChild(navVC);
        navVC.tabBarItem = item;
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
