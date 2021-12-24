//
//  VTObjectMethod.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/22.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

public func VTNSClassFromString(className: String) -> AnyClass? {
    let workName = Bundle.main.infoDictionary?["CFBundleExecutable"] as! String
    let class_VC: AnyClass? = NSClassFromString("\(workName).\(className)") ?? nil
    return class_VC
}
