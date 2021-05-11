//
//  VTMainViewModel.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/25.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

// token过期时间
let tokenExpireTime: NSInteger = 1;

class VTMainViewModel: VTBaseViewModel {
    /**
     * 展示新手引导
     */
    open func showUserGuideView() -> Bool {
        return Defaults[\.isNewUser];
    }
    
    /**
     * 判断登录是否过期
     */
    open func loginExpirOrNot() {
        VTGlobalStatusModel.shared.userInfoModel = VTUserInfoCache.getCacheUserModel();
        printLog("用户信息 %@",VTGlobalStatusModel.shared.userInfoModel ?? "没有用户信息");
        if VTGlobalStatusModel.shared.userInfoModel != nil && VTGlobalStatusModel.shared.isLogin {
            let time = self.getNowTimeStamp();
            let serviceTime = Int(VTGlobalStatusModel.shared.userInfoModel.loginTime!);
            if (serviceTime! - time) > tokenExpireTime {
                VTGlobalStatusModel.shared.rersetData();
                VTUserInfoCache.deleteCacheUserModel();
                VTImageViewController.initWithMessage(message: LanguageTool.language(key: "token已过期,请重新登录"), cancelButtonTitle: nil, otherButtonTitle: nil) { (index) in
                    printLog(index);
                };
            } else {
                printLog("登陆未超时");
            }
        } else {
            printLog("未登录");
        }
    }
    
    /**
     * 检测版本更新
     */
    open func checkAppVersion() {
        appVersion();
    }
    
    // 版本检测
    private func appVersion() {
        VersionProvider.request(VersionAPI.CheckAppVersion) { (result) in
            if case .success(let response) = result {
               // 解析数据
                let jsonDic = try! response.mapJSON() as! NSDictionary
                let versionModel: VTVersionModel = VTVersionModel.dictionaryToModel(jsonDic["data"] as! [String : Any],VTVersionModel.self) as! VTVersionModel;
                if versionModel.state == 0 {
                    // 软更新
                } else if versionModel.state == 1 {
                    // 强制更新
                } else if versionModel.state == 2 {
                    // 没有新版本
                }
            }
        }
    }
}
