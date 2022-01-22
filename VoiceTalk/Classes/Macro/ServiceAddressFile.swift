//
//  ServiceAddressFile.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/16.
//  Copyright © 2021 macos. All rights reserved.
//

import Foundation

/// 测试环境地址
let DebugServiceAddress = "https://api.kkgoo.cn/";
/// 正式环境地址
let ReleaseServiceAddress = "https://api.kkgoo.cn/";
/// log环境地址
let LogServiceAddress = "http://log.kkgoo.cn/";

#if DEBUG
let ServiceAddress = DebugServiceAddress;
#else
let ServiceAddress = ReleaseServiceAddress;
#endif
