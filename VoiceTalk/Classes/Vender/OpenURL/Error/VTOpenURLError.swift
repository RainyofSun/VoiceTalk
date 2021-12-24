//
//  VTOpenURLError.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/13.
//  Copyright © 2021 macos. All rights reserved.
//

import Foundation


let VTOpenURLErrorDomain: String = "VTOpenURLErrorDomain"

/*
 Swift中的枚举默认是没有原始值的, 但是可以在定义时告诉系统让枚举有原始值
 Swift中的枚举除了可以指定整形以外还可以指定其它类型, 但是如果指定其它类型, 必须给所有枚举值赋值, 因为不能自动递增
 */
public enum VTOpenURLError : Int {
    case VTOpenURLBadURLError = 1001
    case VTOpenURLNoContextError
    case VTOpenURLNoControllerError
    case VTOpenURLBadParametersError
    case VTOpenURLNeedLoginError
}
