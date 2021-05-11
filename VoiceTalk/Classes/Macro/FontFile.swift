//
//  FontFile.swift
//  VoiceTalk
//
//  Created by macos on 2021/5/7.
//  Copyright © 2021 macos. All rights reserved.
//

import Foundation

// 字体
func appFont(fontSize:CGFloat) -> UIFont {
    let lanuage = UserDefaults.standard.object(forKey: "AppleLanguages") as! Array<String>;
    
    if lanuage.first == "zh-Hans-CN" || lanuage.first == "zh-Hant-CN" || lanuage.first == "zh-HK" {
        // 简体中文/繁体中文
        return UIFont.init(name: "Resource-Han-Rounded-CN-Medium", size: fontSize)!;
    } else if lanuage.first == "en_CN" {
        return UIFont.init(name: "Futura-Medium", size: fontSize)!;
    }
    return UIFont.systemFont(ofSize: fontSize);
}

