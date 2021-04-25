//
//  UserDefaultsKeyFile.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/25.
//  Copyright © 2021 macos. All rights reserved.
//

import Foundation

extension DefaultsKeys{
    // 是否是新用户
    var isNewUser: DefaultsKey<Bool> { .init("isNewUser", defaultValue: true)};
}

