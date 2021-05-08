//
//  Date.swift
//  VoiceTalk
//
//  Created by macos on 2021/5/6.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

extension NSObject {
    /// 获取当前时间戳-->秒
    func getNowTimeStamp() -> Int {
        return Int(Date.init(timeIntervalSinceNow: 0).timeIntervalSince1970);
    }
}
