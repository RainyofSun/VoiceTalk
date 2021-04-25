//
//  MacroFile.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/16.
//  Copyright © 2021 macos. All rights reserved.
//

import Foundation
import UIKit

// 系统判断
// 获取系统版本
let ios_version = Double(UIDevice().systemVersion);
// 大于 iOS 10的系统
let above_ios_10 = ios_version! >= 10.0 ? true : false;

// 屏幕宽度
let screen_width = UIScreen.main.bounds.size.width;
let screen_height = UIScreen.main.bounds.size.height;

// window
let KeyWindow = UIApplication.shared.delegate?.window;


// 设备判断

let iphone_X = isIphoneX();

/*状态栏高度*/
let kStatusBarHeight = iphone_X ? 44.0 : 20.0;
/*导航栏高度*/
let kNavbarHeight = 44.0;
/*状态栏和导航栏总高度*/
let kNavBarAndStatusBarHeight = iphone_X ? 88.0 : 64.0;
/*TabBar高度*/
let kTabBarHeight = iphone_X ? (49.0 + 34.0) : 49.0;
/*顶部安全区域远离高度*/
let kTopBarSafeHeight = iphone_X ? 44.0 : 0;
/*底部安全区域远离高度*/
let kBottomBarSafeHeight = iphone_X ? 34.0 : 0;

/**
  使用：printLog("hello world")   debug模式打印，release模式不打印
  使用：printLog("hello world", logError: true) release模式也可打印
*/
func printLog(_ items: Any...,logError: Bool = false, file: String = #file, method: String = #function, line: Int = #line) {
    if logError {
        print(message: items, fileName: file,methodName: method,lineNumber: line)
    } else {
        #if DEBUG
            print(message: items, fileName: file,methodName: method,lineNumber: line)
        #endif
    }
}

private func print<T>(message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line) {
    //获取当前时间
    let now = Date()
    // 创建一个日期格式器
    let dformatter = DateFormatter()
    dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    // 要把路径最后的字符串截取出来
    let lastName = ((fileName as NSString).pathComponents.last!)
    print("\(dformatter.string(from: now)) [\(lastName)][第\(lineNumber)行] \n\t\t \(message)")
}

private func isIphoneX() -> Bool {
    let phoneSize = Float(String(format: "%.2f", screen_height/screen_width));
    let standerSize = Float(String(format: "%.2f", 16.0/9));
    return phoneSize! > standerSize!;
}





