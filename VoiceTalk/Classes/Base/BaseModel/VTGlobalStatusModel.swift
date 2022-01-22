//
//  VTGlobalStatusModel.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/25.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit
/*
 全局单例类
 */
class VTGlobalStatusModel: NSObject {
    
    /** 全局用户信息 */
    var userInfoModel: VTBaseUserInfoModel!;
    /** 用户是否登陆 */
    var isLogin :Bool {
        get {
            if self.userInfoModel != nil {
                return self.userInfoModel.token != nil && self.userInfoModel.token?.count != 0
            }
            return false
        }
    }
    
    static let shared = VTGlobalStatusModel();
    
    private override init() {}
    
    override func copy() -> Any {
        return self;
    }
    
    override func mutableCopy() -> Any {
        return self;
    }
    
    func rersetData() {
        printLog("重置所有的数据");
        userInfoModel = nil;
    }
}
