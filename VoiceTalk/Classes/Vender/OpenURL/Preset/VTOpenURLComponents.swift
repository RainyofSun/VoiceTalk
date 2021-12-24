//
//  VTOpenURLComponents.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/13.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

// Swift 位移枚举
struct VTOpenURLType: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    public static var scheme : VTOpenURLType{return VTOpenURLType(rawValue: 1<<0)}
    public static var webPage : VTOpenURLType{return VTOpenURLType(rawValue: 1<<1)}
}

class VTOpenURLComponents: NSObject {
    
    var url: NSURL?
    var type: VTOpenURLType?
    var scheme: String?
    var pathComponents: Array<Any>?
    
    init?(componentsUrl:NSURL!) {
        guard let host = componentsUrl.host else { return nil }
        guard let scheme = componentsUrl.scheme else { return nil }
        var schemeType: Bool = false
        if scheme == "http" || scheme == "https" {
            if !VTOpenURLManager.shared.webHosts.contains(host) {
                return nil
            }
        } else if !VTOpenURLManager.shared.schemes.contains(scheme) {
            return nil
        } else {
            schemeType = true
        }
        guard let path = componentsUrl.path else { return nil }
        var pathComponents: Array<String> = path.components(separatedBy: "/")
        pathComponents = pathComponents.filter{return $0.lengthOfBytes(using: .utf8) != 0}
        if schemeType {
            pathComponents.insert(host, at: 0)
        }
        self.url = componentsUrl
        self.pathComponents = pathComponents
        self.scheme = scheme
        self.type = schemeType ? VTOpenURLType.scheme : VTOpenURLType.webPage
    }
    
    deinit {
        printLog("DELLOC : ",self.description)
    }
}
