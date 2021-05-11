//
//  VTVersionModel.swift
//  VoiceTalk
//
//  Created by macos on 2021/5/11.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTVersionModel: VTBaseModel {
    var androidVersion : Int?
    var appVersion : String?
    var iosVersion : Int?
    var note : String?
    var state : Int? // 0 软更新 1 强制更新 2 没有新版本
    var title : String?
}
