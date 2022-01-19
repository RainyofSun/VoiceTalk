//
//  VersionAPI.swift
//  VoiceTalk
//
//  Created by macos on 2021/5/10.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

let VersionProvider = MoyaProvider<VersionAPI>();

enum VersionAPI {
    case CheckAppVersion
    case Login
}

extension VersionAPI:TargetType {
    var baseURL: URL {
        return URL.init(string: ServiceAddress)!
    }
    
    var path: String {
        switch self {
        case .CheckAppVersion:
            return CheckVersion;
        case .Login:
            return "account/login?".addExtensionParams()
        }
    }
    
    var method: Moya.Method {
        return .post;
    }
    
    // 这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        let params : [String : Any] = ["iosVersion": currentVersion,"appVersion": minorVersion];
        switch self {
        case .CheckAppVersion:
            return .requestData(params.mapToJson());
        case .Login:
            let parameters = ["country": "1","mobile":"10112521511",
                              "password":VTRSAEncrypo.rsaEncrypotoTheData("1234567"),
                              "platform":"mobile"]
            let salt: String = VTSalt.salt()
            let jsonStr: String = String.convertDictionaryToString(dict: parameters)
            let sign: String = VTNetSign.signWithContent(content: jsonStr, salt: salt)
            let signKey: String = "nice-sign-v1://" + sign
            let signValue: String = salt + "/" + jsonStr
            return .requestData([signKey:signValue].mapToJson())
        }
    }
    
    // 请求头
    var headers: [String : String]? {
        return ["Content-Type":"application/json",
                "version":"1.0.0"];
    }
    
    // 是否执行Alamofire验证
    public var validate: Bool {
        return false;
    }
}
