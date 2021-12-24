//
//  VTServer.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/9.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTServer: NSObject {
    var rootUrl: String = ServiceAddress
    var headers: [String:String]? = defaultHeaders()
    var parameters : [String : Any]? = defaultParameters()
    var timeOutInterval : Double = 20.0  // 请求超时时间
    
    static let shared = VTServer();
    private override init() {};
    
    static func defaultHeaders() -> [String : String]? {
        return ["deviceID":"122","Authorization":""];
    }
    
    static func defaultParameters() -> [String : Any]? {
        return ["platform" : "ios",
                "version" : "1.2.3",
        ];
    }
}
