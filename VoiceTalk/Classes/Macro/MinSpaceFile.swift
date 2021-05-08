//
//  MinSpaceFile.swift
//  VoiceTalk
//
//  Created by macos on 2021/5/7.
//  Copyright © 2021 macos. All rights reserved.
//

import Foundation

/// 最小间距
let minSpace = 4.0;

/// 间距
func space(times:Double) -> Double {
    return minSpace * times;
}
