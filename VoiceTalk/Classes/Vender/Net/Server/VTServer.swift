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
    var parameters : [String : Any] = defaultParameters()
    var timeOutInterval : Double = 20.0  // 请求超时时间
    
    static let shared = VTServer();
    private override init() {};
    
    static func defaultHeaders() -> [String : String]? {
        return ["deviceID":VTDeviceID.VTDeviceID32(),"Authorization":""];
    }
    
    static func defaultParameters() -> [String : Any] {
        var tempParameters: [String: Any] = ["appv" : currentVersion,
                                               "osn" : "iOS",
                                               "did": VTDeviceID.VTDeviceID32()]
        if VTGlobalStatusModel.shared.userInfoModel != nil && VTGlobalStatusModel.shared.userInfoModel.token != nil {
            tempParameters["token"] = VTGlobalStatusModel.shared.userInfoModel.token!
        }
        return tempParameters
    }
}
