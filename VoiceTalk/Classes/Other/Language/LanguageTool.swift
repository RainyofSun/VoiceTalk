//
//  LanguageTool.swift
//  VoiceTalk
//
//  Created by macos on 2021/5/8.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

/*
 * 语言工具类
 */

class LanguageTool: NSObject {
    
    // MARK: 文件目录
    static let CHINESE = "zh-Hans"
    static let ENGLISH = "en"
    
    /// 获取多语言字符
    class func language(key:String) -> String {
        return NSLocalizedString(key, tableName: "", bundle: bundle(), value: "", comment: "");
    }
    
    /// 切换语言
    class func resetLanguage(languageName:String) {
        UserDefaults.standard.setValue([languageName], forKey: "AppleLanguages");
        UserDefaults.standard.synchronize();
    }
    
    /// 获取多语言类型
    private class func getLanguageType() -> String {
        let languages : [String] = UserDefaults.standard.object(forKey: "AppleLanguages") as! Array;
        let lanuage : String = languages.first!;
        
        if lanuage.hasPrefix(CHINESE) {
            return CHINESE;
        }
        return ENGLISH;
    }
    
    private class func bundle() -> Bundle {
        guard let path = Bundle.main.path(forResource: self.getLanguageType(), ofType: "lproj"),let bundle = Bundle(path: path) else {
            return Bundle.main;
        }
        return bundle;
    }
}
