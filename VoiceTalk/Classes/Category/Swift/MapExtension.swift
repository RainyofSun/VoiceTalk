//
//  MapExtension.swift
//  VoiceTalk
//
//  Created by macos on 2021/5/11.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

extension Dictionary {
    /// 字典转data
    func mapToJson() -> Data {
        if !JSONSerialization.isValidJSONObject(self) {
            printLog("不是json数据");
            return Data.init();
        }
        let data = try? JSONSerialization.data(withJSONObject: self, options: []);
        let str = String.init(data: data!, encoding: String.Encoding.utf8)!;
        printLog("json 转出数据" + str);
        return data!;
    }
}
