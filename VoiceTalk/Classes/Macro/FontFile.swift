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
    let lanuage = UserDefaults.standard.object(forKey: "AppleLanguages") as! String;
    if lanuage == "zh-Hans-CN" || lanuage == "zh-Hant-CN" || lanuage == "zh-HK" {
        // 简体中文/繁体中文
        return UIFont.init(name: "ResourceHanRoundedCN-Medium", size: fontSize)!;
    } else if lanuage == "en_CN" {
        return UIFont.init(name: "Futura-Medium-6", size: fontSize)!;
    }
    return UIFont.systemFont(ofSize: fontSize);
}

