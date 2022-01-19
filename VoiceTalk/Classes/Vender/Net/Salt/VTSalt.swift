//
//  VTSalt.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/11.
//  Copyright © 2022 macos. All rights reserved.
//

import UIKit

class VTSalt: NSObject {
    class func salt() -> String {
        let uuidStr: NSString = UUID().uuidString as NSString
        return uuidStr.vt_MD5().substringWithRange(loc: 15, len: 16)
    }
}
