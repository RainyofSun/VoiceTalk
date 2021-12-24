//
//  VTOpenURLPreset.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/13.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

enum VTOpenPageStyle: Int {
    case VTOpenPageStyleDefault = -1
    case VTOpenPageStylePush
    case VTOpenPageStylePresent
    case VTOpenPageStyleExist
    case VTOpenPageStylePop
}

/*
 Any代表任意类型；
 AnyObject代表任意类类型；
 X.self 获取一个元类型指针;
 X.Type代表一个X元类型
 AnyObject.Type 代表任意元类型；
 AnyClass = AnyObject.Type
 */
class VTOpenURLPreset: NSObject {
    
    let kWebURLIgnoreParamsKey: String = "kWebURLIgnoreParamsKey"
    var type: VTOpenURLType?
    var contextClass: AnyClass?
    var controllerClass: AnyClass?
    var parentControllerClass: AnyClass?
    var openPageStyle: VTOpenPageStyle?
    var path: String?
    fileprivate(set) var pathComponents: Array<String>?
    
    // Mark public methods
    public static func presentWithPath(path: String,presentData:Dictionary<String, String>) ->VTOpenURLPreset {
        return VTOpenURLPreset.init(path: path, presentData: presentData)
    }
    
    public func validateURLComponents(urlComponents:VTOpenURLComponents) -> Bool {
        guard (self.contextClass != nil) else {
            return false
        }
        /*
         1.添加多个枚举值条件Swift 不再是用| 而是用[.xxx,.xxx] 类似于数组的方式 添加多个枚举值条件
         2.判断 位移枚举的变量是否存在 Swift 不再是用& 而是用.contains()
         */
        guard (self.type!.contains(urlComponents.type!)) else {
            return false
        }
        guard (urlComponents.pathComponents?.count == self.pathComponents?.count) else {
            return false
        }
        for i in 0 ..< urlComponents.pathComponents!.count {
            let component: String = urlComponents.pathComponents![i] as! String
            let filerComponent = self.pathComponents?[i] ?? ""
            if !filerComponent.hasPrefix(":") && component != filerComponent {
                return false
            }
        }
        return true
    }
    
    // Mark init methods
    init(path:String,presentData:Dictionary<String,String>) {
        self.path = path
        let components: Array<String> = path.components(separatedBy: "/")
        self.pathComponents = components.filter{ return $0.lengthOfBytes(using: .utf8) != 0}
        guard let contextName = presentData["context"] else {
            printLog("VTOpenURLPreset: contextName nil")
            return
        }
        self.contextClass = VTNSClassFromString(className: contextName)
        if let controllerClassName = presentData["controller"] {
            self.controllerClass = VTNSClassFromString(className: controllerClassName)
        }
        if let parentControllerName = presentData["parent"] {
            self.parentControllerClass = VTNSClassFromString(className: parentControllerName)
        }
        if let presentType = presentData["type"] {
            self.type = VTOpenURLType.init(rawValue: Int(presentType)!)
        } else {
            self.type = [VTOpenURLType.scheme,VTOpenURLType.webPage]
        }
        let open_style = presentData["open_style"] ?? "0"
        self.openPageStyle = VTOpenPageStyle.init(rawValue: Int(open_style)!)
    }
    
    deinit {
        printLog("DELLOC : ",self.description)
    }
}
