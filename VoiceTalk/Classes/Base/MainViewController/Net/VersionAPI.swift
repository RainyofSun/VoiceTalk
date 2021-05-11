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
    case CheckAppVersion;
}

extension VersionAPI:TargetType {
    var baseURL: URL {
        switch self {
        case .CheckAppVersion:
            return URL.init(string: ServiceAddress + CheckVersion)!;
        }
    }
    
    var path: String {
        switch self {
        case .CheckAppVersion:
            return "";
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
