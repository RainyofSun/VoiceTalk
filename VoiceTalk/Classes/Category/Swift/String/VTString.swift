//
//  VTString.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/10.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

extension String {

    func substringFromIndex(index:Int) ->String {
        guard index < self.count else {
            printLog("超出边界")
            return ""
        }
        var tempStr = self
        let subIndex = index < 0 ? 0 : index
        let targetIndex = tempStr.index(tempStr.startIndex, offsetBy: subIndex)
        tempStr.removeSubrange(tempStr.startIndex...targetIndex)
        return tempStr
    }
    
    func substringToIndex(index:Int) ->String {
        guard index < self.count else {
            printLog("超出边界")
            return ""
        }
        let subIndex = index < 0 ? 0 : index
        var tempStr = self
        let targetIndex = tempStr.index(tempStr.startIndex, offsetBy: subIndex)
        tempStr.removeSubrange(targetIndex...)
        return tempStr
    }
    
    func substringWithRange(loc:Int,len:Int) ->String {
        guard loc < self.count else {
            printLog("裁剪位置超出边界")
            return ""
        }
        guard len < self.count else {
            printLog("裁剪长度超出边界")
            return ""
        }
        let subIndex = loc < 0 ? 0 : loc
        let end = subIndex + len - 1
        guard end < self.count else {
            printLog("裁剪长度超出边界")
            return ""
        }
        let tempStr = self
        let startIndex = tempStr.index(tempStr.startIndex, offsetBy: subIndex)
        let endIndex = tempStr.index(tempStr.startIndex, offsetBy: end)
        return String.init(tempStr[startIndex...endIndex])
    }
    
    func stringByReplacingOccurrencesOfString(replaceString:String,targetString:String) ->String {
        guard self.contains(replaceString) else {
            printLog("不包含要替换的字符")
            return ""
        }
        var tempStr = self
        tempStr = tempStr.replacingOccurrences(of: replaceString, with: targetString)
        return tempStr
    }
}


