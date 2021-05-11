//
//  VTMainViewController.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/15.
//  Copyright © 2021 macos. All rights reserved.
//
/*
 // 有参数无返回值的
 typealias Myclosure1 = (String) ->Void
 // 有参数无返回值的
 typealias Myclosure2=(String) ->String
 // 两个参数,一个返回值
 typealias Myclosure3=(String, String)->String
 // 无参数，无返回值
 typealias Myclosure4=()->Void
 */
import UIKit

class VTMainViewController: UIViewController {
    
    let reachability = try! Reachability();
    let mainVM = VTMainViewModel();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 开始网络监测
        openNetworkStatusObserver();
        loadTabbarController();
        self.mainVM.loginExpirOrNot();
        addUserGuideView();
        // Do any additional setup after loading the view.
        let lab = UILabel.init();
        lab.text = LanguageTool.language(key: "我知道了");
        lab.textColor = mainColor;
        self.view.addSubview(lab);
        lab.snp.makeConstraints { (make) in
            make.center.equalTo(self.view);
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.mainVM.checkAppVersion();
    }
    
    deinit {
        printLog(String(format: "%@", self));
        reachability.stopNotifier();
    }
 
    // 开启网络监测
    private func openNetworkStatusObserver() {
        reachability.whenReachable = { reachability in
            if reachability.connection == Reachability.Connection.wifi {
                printLog("当前网络为Wi-Fi");
            } else if reachability.connection == Reachability.Connection.cellular {
                printLog("当前网络类型为 流量");
            } else if reachability.connection == Reachability.Connection.unavailable {
                printLog("当前网络不可达");
            }
        }
        try?reachability.startNotifier();
    }
    
    private func addUserGuideView() {
        if !mainVM.showUserGuideView() {
            printLog("不是新用户");
            return;
        }
        let guideVC = AppGuideAnimationViewController();
        self.view.addSubview(guideVC.view);
        self.addChild(guideVC);
        guideVC.switchVC = {
            guideVC.view.removeFromSuperview();
            guideVC.removeFromParent();
            Defaults[\.isNewUser] = false;
        };
    }
    
    private func loadTabbarController() {
        let tabbar = VTTabbarViewController();
        self.view.addSubview(tabbar.view);
        self.addChild(tabbar);
        tabbar.view.snp.makeConstraints { (make) in
            make.left.bottom.right.top.equalToSuperview();
        }
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
