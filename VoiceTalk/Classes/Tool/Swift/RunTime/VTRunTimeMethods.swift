//
//  VTRunTimeMethods.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/7.
//  Copyright © 2022 macos. All rights reserved.
//

import UIKit

class VTRunTimeMethods: NSObject {
    /*
     * 获取类内部属性
     */
    class func getClassPropertyNames(classType: AnyClass) {
        var propertyCount: UInt32 = 0
        let props: UnsafeMutablePointer<objc_property_t> = class_copyPropertyList(classType, &propertyCount)!
        let count: Int = Int(propertyCount)
        for i in 0..<count {
            let property: objc_property_t = props[i]
            guard let propName: String? = String(cString: property_getName(property)) else {
                return
            }
            printLog("属性名 " + propName!)
        }
        free(props)
    }
    
    /*
     * 获取类内部对象
     */
    class func getClassIvarsNames(classType: AnyClass) {
        var ivarCount: UInt32 = 0
        let props: UnsafeMutablePointer<Ivar> = class_copyIvarList(classType, &ivarCount)!
        let count: Int = Int(ivarCount)
        for i in 0..<count {
            let property: Ivar = props[i]
            guard let name = ivar_getName(property) else {
                printLog("获取失败")
                return
            }
            printLog("实例 " + String(cString: name))
        }
        free(props)
    }
}
