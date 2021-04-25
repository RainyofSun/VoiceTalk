//
//  VTUserInfoCache.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/25.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

let accountFileName = "accountFileName";

class VTUserInfoCache: NSObject {
    
    /**
     * 序列化用户信息
     */
    open func saveCacheUserInfoModel() {
        
    }
    
    /**
     * 获取用户信息
     */
    open func getCacheUserModel() {
        
    }
    
    /**
     * 删除用户信息
     */
    open func deleteCacheUserModel() {
        
    }
    
    private func saveData(fileName: String, modelData:Any) {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last;
        let accountPath = documentPath! + String(format: "/%@.data", fileName);
        printLog("路径 %@",accountPath);
        let keyUUnarchiver:NSKeyedArchiver = try! NSKeyedArchiver(forWritingWith: modelData as! NSMutableData);
        
    }
}
