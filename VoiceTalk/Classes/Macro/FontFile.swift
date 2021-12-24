//
//  FontFile.swift
//  VoiceTalk
//
//  Created by macos on 2021/5/7.
//  Copyright © 2021 macos. All rights reserved.
//

import Foundation
import UIKit

// 常规字号
let VTNormalFont10: UIFont = appFont(fontSize: 10)
let VTNormalFont11: UIFont = appFont(fontSize: 11)
let VTNormalFont12: UIFont = appFont(fontSize: 12)
let VTNormalFont13: UIFont = appFont(fontSize: 13)
let VTNormalFont14: UIFont = appFont(fontSize: 14)
let VTNormalFont15: UIFont = appFont(fontSize: 15)
let VTNormalFont16: UIFont = appFont(fontSize: 16)
let VTNormalFont17: UIFont = appFont(fontSize: 17)
let VTNormalFont18: UIFont = appFont(fontSize: 18)
let VTNormalFont24: UIFont = appFont(fontSize: 24)

// 中等字号
let VTMediumFont10: UIFont = appFont(fontSize: 10, weight: .medium)
let VTMediumFont11: UIFont = appFont(fontSize: 11, weight: .medium)
let VTMediumFont12: UIFont = appFont(fontSize: 12, weight: .medium)
let VTMediumFont13: UIFont = appFont(fontSize: 13, weight: .medium)
let VTMediumFont14: UIFont = appFont(fontSize: 14, weight: .medium)
let VTMediumFont15: UIFont = appFont(fontSize: 15, weight: .medium)
let VTMediumFont16: UIFont = appFont(fontSize: 16, weight: .medium)
let VTMediumFont17: UIFont = appFont(fontSize: 17, weight: .medium)
let VTMediumFont18: UIFont = appFont(fontSize: 18, weight: .medium)
let VTMediumFont24: UIFont = appFont(fontSize: 24, weight: .medium)

// 粗体
let VTBoldFont10: UIFont = appBoldFont(fontSize: 10)
let VTBoldFont11: UIFont = appBoldFont(fontSize: 11)
let VTBoldFont12: UIFont = appBoldFont(fontSize: 12)
let VTBoldFont13: UIFont = appBoldFont(fontSize: 13)
let VTBoldFont14: UIFont = appBoldFont(fontSize: 14)
let VTBoldFont15: UIFont = appBoldFont(fontSize: 15)
let VTBoldFont16: UIFont = appBoldFont(fontSize: 16)
let VTBoldFont17: UIFont = appBoldFont(fontSize: 17)
let VTBoldFont18: UIFont = appBoldFont(fontSize: 18)
let VTBoldFont24: UIFont = appBoldFont(fontSize: 24)

// 字体
func appFont(fontSize:CGFloat, weight:UIFont.Weight? = .regular) -> UIFont {
    let lanuage = UserDefaults.standard.object(forKey: "AppleLanguages") as! Array<String>;
    
    if lanuage.first == "zh-Hans-CN" || lanuage.first == "zh-Hant-CN" || lanuage.first == "zh-HK" {
        // 简体中文/繁体中文
        return UIFont.init(name: "Resource-Han-Rounded-CN-Medium", size: fontSize)!;
    } else if lanuage.first == "en_CN" {
        return UIFont.init(name: "Futura-Medium", size: fontSize)!;
    }
    return UIFont.systemFont(ofSize: fontSize, weight: weight!);
}

// 字体
func appBoldFont(fontSize:CGFloat) -> UIFont {
    let lanuage = UserDefaults.standard.object(forKey: "AppleLanguages") as! Array<String>;
    
    if lanuage.first == "zh-Hans-CN" || lanuage.first == "zh-Hant-CN" || lanuage.first == "zh-HK" {
        // 简体中文/繁体中文
        return UIFont.init(name: "Resource-Han-Rounded-CN-Medium", size: fontSize)!;
    } else if lanuage.first == "en_CN" {
        return UIFont.init(name: "Futura-Medium", size: fontSize)!;
    }
    return UIFont.systemFont(ofSize: fontSize);
}

