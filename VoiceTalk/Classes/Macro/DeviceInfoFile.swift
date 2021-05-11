//
//  DeviceInfoFile.swift
//  VoiceTalk
//
//  Created by macos on 2021/5/10.
//  Copyright © 2021 macos. All rights reserved.
//

import Foundation

//获取当前版本号
let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
//获取历史版本号
let sandboxVersion = UserDefaults.standard.object(forKey: "CFBundleShortVersionString") as? String ?? ""

//版本比较
func findNewVersion() -> Bool {
    let isNewVersion : Bool = currentVersion.compare(sandboxVersion) == ComparisonResult.orderedDescending;
    if isNewVersion {
       //发现新版本 存储当前的版本到沙盒
       UserDefaults.standard.set(currentVersion, forKey: "CFBundleShortVersionString")
    }
    return isNewVersion;
}

//获取app信息
let infoDictionary : Dictionary = Bundle.main.infoDictionary!
//程序名称
let appDisplayName : String = infoDictionary["CFBundleDisplayName"] as! String
//版本号
let majorVersion :String = infoDictionary ["CFBundleShortVersionString"] as! String
//build号
let minorVersion :String = infoDictionary ["CFBundleVersion"] as! String

//获取设备信息
//ios版本
let iosVersion : NSString = UIDevice.current.systemVersion as NSString
//设备udid
let identifierNumber  = UIDevice.current.identifierForVendor
//设备名称
let deviceName : String = UIDevice.current.name
//系统名称
let systemName : String = UIDevice.current.systemName
//设备型号
let model = UIDevice.current.model
//设备区域化型号如A1533
let localizedModel = UIDevice.current.localizedModel
