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
    static func saveCacheUserInfoModel() {
        saveData(modelData: VTGlobalStatusModel.shared.userInfoModel);
    }
    
    /**
     * 获取用户信息
     */
    static func getCacheUserModel() -> VTBaseUserInfoModel {
        return getSaveData();
    }
    
    /**
     * 删除用户信息
     */
    static func deleteCacheUserModel() {
        clearCache();
    }
    
    private static func saveData(modelData:VTBaseUserInfoModel) {
        let fileCachePath = filePath();
        NSKeyedArchiver.archiveRootObject(modelData, toFile: fileCachePath);
    }
    
    private static func getSaveData() -> VTBaseUserInfoModel {
        let fileCachePath = filePath();
        let archive = NSKeyedUnarchiver.unarchiveObject(withFile: fileCachePath) as! VTBaseUserInfoModel;
        return archive;
    }
    
    private static func clearCache() {
        let fileCachePath = filePath();
        NSKeyedArchiver.archiveRootObject(VTBaseUserInfoModel(), toFile: fileCachePath);
    }
    
    private static func filePath() ->String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last;
        let fileCachePath = documentPath! + String(format: "/%@.data", accountFileName);
        printLog("路径 %@",fileCachePath);
        return fileCachePath;
    }
}
