//
//  Date.swift
//  VoiceTalk
//
//  Created by macos on 2021/5/6.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit
import AttributedString

extension Date {
    
    // 获取当前时间时间戳 单位毫秒
    static func timestampString() -> String {
        return String(format: "%lld", Date.init().timeIntervalSince1970 * 1000)
    }
    
    static func dateWithString(timeStr: String) -> Date {
        return Date.dateFormatter().date(from: timeStr) ?? Date.init()
    }
    
    static func timeWithString(timeStr: String) -> Date {
        return Date.timeFormatter().date(from: timeStr) ?? Date.init()
    }
    
    static func highResolutionTimeWithString(timeStr: String) -> Date {
        return self.highResolutionTimeFormatter().date(from: timeStr) ?? Date.init()
    }
    
    static func judgeDateIsToday(date: Date) -> Bool {
        let dateStr: String = date.dateString()
        if dateStr == Date.init().dateString() {
            return true
        }
        return false
    }
    
    static func judgeExceedHalfDay(date: Date) -> Bool {
        let timeInterval: TimeInterval = Date.init().timeIntervalSince(date)
        if timeInterval < 12 * 60 * 60 {
            return false
        } else {
            return true
        }
    }
    
    // 获取当前时间戳-->秒
    static func getNowTimeStamp() -> Int {
        return Int(Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970);
    }
    
    func dateString() -> String {
        return Date.dateFormatter().string(from: self)
    }
    
    func timeString() -> String {
        return Date.timeFormatter().string(from: self)
    }
    
    func detailTimeStringYYYYMMddHH() -> String {
        return Date.detailTimeFormatter().string(from: self)
    }
    
    func relativeFormattedString(detail: Bool) -> String {
        let nowDate: Date = Date.init()
        let dateFormatter: DateFormatter = Date.dateFormatterFromCurrentThread()
        let nowComponents: DateComponents = Calendar.current.dateComponents([.year,.month,.day], from: nowDate)
        let dateComponents: DateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: self)
        let yesterdayComponents: DateComponents = Calendar.current.dateComponents([.year,.month,.day], from: nowDate.addingTimeInterval(-24 * 60 * 60))
        let dayComponents: DateComponents = Calendar.current.dateComponents([.day], from: self, to: nowDate)
        var formatterStr: String = ""
        
        let isToday: Bool = (nowComponents.year == dateComponents.year) &&
                            (nowComponents.month == dateComponents.month) &&
                            (nowComponents.day == dateComponents.day)
        let isYesterday: Bool = (yesterdayComponents.year == dateComponents.year) &&
                                (yesterdayComponents.month == dateComponents.month) &&
                                (yesterdayComponents.day == dateComponents.day)
        if isToday {
            
        } else if isYesterday {
            formatterStr = VTStr(str: "昨天")
        } else if dayComponents.day! < 7 {
            if LanguageTool.isChinese() {
                dateFormatter.locale = Locale.init(identifier: "zh_CN")
            } else {
                dateFormatter.locale = Locale.init(identifier: "en")
            }
            dateFormatter.dateFormat = "EEEE"
            formatterStr = dateFormatter.string(from: self).capitalized
        } else {
            dateFormatter.locale = Locale.init(identifier: "zh_CN")
            dateFormatter.dateFormat = "yyyy-M-d"
            formatterStr = dateFormatter.string(from: self)
        }
        let isPrefer24Hour = self.prefers24Hour()
        if detail || isToday {
            if isPrefer24Hour {
                dateFormatter.dateFormat = "HH:mm"
            } else {
                dateFormatter.dateFormat = "hh:mm"
            }
            let timeStr: String = dateFormatter.string(from: self)
            if formatterStr.count != 0 {
                formatterStr = formatterStr + " "
            }
            if !isPrefer24Hour {
                if dateComponents.hour! > 12 {
                    formatterStr = formatterStr + VTStr(str: "下午") + timeStr
                } else {
                    formatterStr = formatterStr + VTStr(str: "上午") + timeStr
                }
            } else if dateComponents.hour! >= 0 && dateComponents.hour! <= 5 {
                formatterStr = formatterStr + VTStr(str: "凌晨") + String(format: "%02ld", dateComponents.hour!) + String(format: "%02ld", dateComponents.minute!)
            } else {
                formatterStr = formatterStr + timeStr
            }
        }
        return formatterStr
    }
    
    func highResolutionTimeString() -> String {
        return Date.highResolutionTimeFormatter().string(from: self)
    }
    
    func hourDateString() -> String {
        return Date.hourFormatter().string(from: self)
    }
    
    func mouthDayString() -> String {
        return Date.monthFormatter().string(from: self)
    }
    
    // 如: 1分钟前
    func timeStringRelativeNow() -> String {
        let interval: TimeInterval = Date.init().timeIntervalSince(self)
        return self.timeStringRelativeInterval(interval: interval)
    }
    // 直播问答,今天,明天,几月几日
    func timeStringForLiveHQ() -> String {
        let nowDate: Date = Date.init()
        let dateFormatter: DateFormatter = Date.dateFormatterFromCurrentThread()
        let nowComponents: DateComponents = Calendar.current.dateComponents([.year,.month,.day], from: nowDate)
        let dateComponents: DateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: self)
        let tomorrowComponents: DateComponents = Calendar.current.dateComponents([.year,.month,.day], from: nowDate, to: nowDate.addingTimeInterval(24 * 60 * 60))
        var formattedString: String = ""
        let isToday: Bool = (nowComponents.year == dateComponents.year) &&
                            (nowComponents.month == dateComponents.month) &&
                            (nowComponents.day == dateComponents.day)
        let isTomorrow: Bool = (tomorrowComponents.year == dateComponents.year) &&
                                (tomorrowComponents.month == dateComponents.month) &&
                                (tomorrowComponents.day == dateComponents.day)
        if isToday {
            dateFormatter.dateFormat = "HH:mm"
            formattedString = "今天" + dateFormatter.string(from: self)
        } else if isTomorrow {
            dateFormatter.dateFormat = "HH:mm"
            formattedString = "明天" + dateFormatter.string(from: self)
        } else {
            dateFormatter.dateFormat = "MM月dd日 HH:mm"
            formattedString = dateFormatter.string(from: self)
        }
        return formattedString
    }
    
    func timeStringRelativeInterval(interval: TimeInterval) -> String {
        var timeStr: String = ""
        if interval < 0 {
            timeStr = self.dateString()
        } else if interval < 60 {
            timeStr = VTStr(str: "1分钟前")
        } else if interval < 60 * 60 {
            timeStr = String(format: "%zd%@", interval/60,VTStr(str: "分钟前"))
        } else if interval < 60 * 60 * 24 {
            timeStr = String(format: "%zd%@", interval/3600,VTStr(str: "小时前"))
        } else if interval < 60 * 60 * 24 * 31 {
            timeStr = String(format: "%zd%@", interval/86400,VTStr(str: "天前"))
        } else if interval < 60 * 60 * 24 * 365 {
            timeStr = self.mouthDayString()
        } else {
            timeStr = self.dateString()
        }
        return timeStr
    }
    
    func dateStringWithFormatter(formater: String) -> String {
        let timeFormatter: DateFormatter = Date.dateFormatterFromCurrentThread()
        timeFormatter.dateFormat = formater
        return timeFormatter.string(from: self)
    }
    
    fileprivate static func dateFormatterFromCurrentThread() -> DateFormatter {
        var dateFormatter: DateFormatter? = Thread.current.threadDictionary.object(forKey: "threadFormatter") as? DateFormatter
        if dateFormatter == nil {
            dateFormatter = DateFormatter.init()
            Thread.current.threadDictionary.setObject(dateFormatter!, forKey: "threadFormatter" as NSCopying)
        }
        return dateFormatter!
    }
    
    fileprivate static func dateFormatter() -> DateFormatter {
        let dateFormatter: DateFormatter = dateFormatterFromCurrentThread()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
    
    fileprivate static func monthFormatter() -> DateFormatter {
        let dateFormatter: DateFormatter = dateFormatterFromCurrentThread()
        dateFormatter.dateFormat = "MM-dd"
        return dateFormatter
    }
    
    fileprivate static func hourFormatter() -> DateFormatter {
        let dateFormatter: DateFormatter = dateFormatterFromCurrentThread()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
    
    fileprivate static func timeFormatter() -> DateFormatter {
        let dateFormatter: DateFormatter = dateFormatterFromCurrentThread()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }
    
    fileprivate static func highResolutionTimeFormatter() -> DateFormatter {
        let dateFormatter: DateFormatter = dateFormatterFromCurrentThread()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return dateFormatter
    }
    
    fileprivate static func detailTimeFormatter() -> DateFormatter {
        let dateFormatter: DateFormatter = dateFormatterFromCurrentThread()
        dateFormatter.dateFormat = "yyyyMMddHH"
        return dateFormatter
    }
    
    fileprivate static func hourMinuteSecondsFormatter() -> DateFormatter {
        let dateFormatter: DateFormatter = dateFormatterFromCurrentThread()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter
    }
    
    fileprivate func prefers24Hour() -> Bool {
        var comps: DateComponents = DateComponents.init()
        comps.hour = 22
        let testDate: Date = Calendar.current.date(from: comps)!
        struct formatterStruct {
            static var formatter: DateFormatter? = nil
        }
        if formatterStruct.formatter == nil {
            formatterStruct.formatter = DateFormatter.init()
            formatterStruct.formatter!.timeStyle = .short
        }
        let testStr: String = formatterStruct.formatter!.string(from: testDate)
        return (testStr.substringToIndex(index: 1) == "2")
    }
}

