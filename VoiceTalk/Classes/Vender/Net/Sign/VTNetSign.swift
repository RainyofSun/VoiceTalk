//
//  VTNetSign.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/12.
//  Copyright © 2022 macos. All rights reserved.
//

import UIKit

class VTNetSign: NSObject {
    class func signWithContent(content: String, salt: String) -> String {
        let decevieID: String = VTDeviceID.VTDeviceID32()
        let cSign: UnsafePointer<CChar> = nice_sign_v3(content.cString(using: .utf8), decevieID.cString(using: .utf8), salt.cString(using: .utf8))
        return String.init(cString: cSign)
    }
}

