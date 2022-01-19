//
//  VTDeviceID.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/12.
//  Copyright © 2022 macos. All rights reserved.
//

import UIKit
import AdSupport

var vt_uuid: String = ""
let VT_UUIDKEY: String = "NICE_UUID"
let VT_SERVICEKEY: String = "NICE_SERVICE"

class VTDeviceID: NSObject {
    
    // 获取设备UUID
    class func VTUUID() -> String {
        if vt_uuid.count == 0 {
            var uuid: String? = nil;
            do {
                try uuid = STKeychain.getPasswordForUsername(VT_UUIDKEY, andServiceName: VT_SERVICEKEY)
            } catch let err as NSError {
                printLog("获取uuid 失败" + err.localizedDescription)
            }
            if uuid == nil {
                uuid = UserDefaults.standard.object(forKey: "uuid") as? String
                if uuid == nil {
                    uuid = NSUUID().uuidString
                }
                do {
                    try STKeychain.storeUsername(VT_UUIDKEY, andPassword: uuid, forServiceName: VT_SERVICEKEY, updateExisting: true)
                } catch let err as NSError {
                    printLog("钥匙串存取uuid 失败" + err.localizedDescription)
                }
            }
            vt_uuid = uuid!
        }
        return vt_uuid
    }
    
    // 获取40位deviceID
    class func deviceIDWithSalt(salt: String) -> String {
        return self.VTDeviceID32() + hashIDWithSalt(salt: salt).substringFromIndex(index: 24)
    }
    
    // 随机生成16位salt
    class func random16BeatsSalt() -> String {
        let ori: String = NSUUID().uuidString
        return ori.substringToIndex(index: 8) + ori.substringFromIndex(index: 28)
    }
    
    // device的前32位 用于标记一台设备
    class func VTDeviceID32() -> String {
        return VTUUID().vt_MD5()
    }
    
    // 广告ID
    class func VTAdvertisingID() -> String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    private class func hashIDWithSalt(salt: String) -> String {
        let ori: String = salt + VTDeviceID32() + "0Ktf9FR9"
        return ori.vt_MD5()
    }
}
