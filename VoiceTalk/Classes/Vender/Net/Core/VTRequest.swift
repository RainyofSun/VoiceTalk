//
//  VTRequest.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/10.
//  Copyright © 2021 macos. All rights reserved.
//

import Foundation
import Moya

public struct VTRequest {
    
}

extension VTRequest {
    @discardableResult
    public static func getJson(_ url: String,
                        parameters: [String : Any]? = nil,
                        callbackQueue: DispatchQueue? = DispatchQueue.main,
                        progress: ProgressBlock? = .none,
                        success: @escaping JsonSuccess,
                        failure: @escaping Failure) -> Cancellable {
        
        let network = VTNetworking<CommonAPI>()
        return network.requestJson(.get(url, parameters: parameters, header: VTNetworkRequestHeader()), callbackQueue: callbackQueue, progress: progress, success: success, failure: failure)
    }
    
    @discardableResult
    public static func postJson(_ url: String,
                         parameters: [String : Any]? = nil,
                         callbackQueue: DispatchQueue? = DispatchQueue.main,
                         progress: ProgressBlock? = .none,
                         success: @escaping JsonSuccess,
                         failure: @escaping Failure) -> Cancellable {
        
        let network = VTNetworking<CommonAPI>()
        return network.requestJson(.post(url, parameters: parameters, header: VTNetworkRequestHeader()), callbackQueue: callbackQueue, progress: progress, success: success, failure: failure)
    }
    
    @discardableResult
    public static func get(_ url: String,
                    parameters: [String : Any]? = nil,
                    callbackQueue: DispatchQueue? = DispatchQueue.main,
                    progress: ProgressBlock? = .none,
                    success: @escaping Success,
                    failure: @escaping Failure) -> Cancellable {
        
        let network = VTNetworking<CommonAPI>()
        return network.request(.get(url, parameters: parameters, header: VTNetworkRequestHeader()), callbackQueue: callbackQueue, progress: progress, success: success, failure: failure)
    }
    
    @discardableResult
    public static func post(_ url: String,
                     parameters: [String : Any]? = nil,
                     callbackQueue: DispatchQueue? = DispatchQueue.main,
                     progress: ProgressBlock? = .none,
                     success: @escaping Success,
                     failure: @escaping Failure) -> Cancellable {
        
        let network = VTNetworking<CommonAPI>()
        return network.request(.post(url, parameters: parameters, header: VTNetworkRequestHeader()), callbackQueue: callbackQueue, progress: progress, success: success, failure: failure)
    }
}

fileprivate enum CommonAPI {
    case get(String, parameters: [String: Any]?, header: [String : String]?)
    case post(String, parameters: [String: Any]?, header: [String : String]?)
}

extension CommonAPI:VTServerType {
    var path: String {
        switch self {
        case .get(let url, _ , _):
            return VTPath(url)
        case .post(let url, _ , _):
            return VTPath(url)
        }
    }
    
    var base: String {
        switch self {
        case .get(let url, _ , _):
            return VTBaseUrl(url)
        case .post(let url, _ , _):
            return VTBaseUrl(url)
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .get(_ , _ , _):
            return .get
        case .post(_ , _ , _):
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        var requeseParameters = VTServer.shared.parameters
        
        var newParameters: [String: Any]?
        
        switch self {
        case .get(_, let parameters, _):
            newParameters = parameters
        case .post(_, let parameters, _):
            newParameters = parameters
        }
        
        if let temp = newParameters {
            temp.forEach { (arg) in
                let (key, value) = arg
                requeseParameters[key] = value
            }
        }
        // 参数加密验签
        let salt: String = VTSalt.salt()
        let jsonStr: String = String.convertDictionaryToString(dict: newParameters ?? [:])
        let sign: String = VTNetSign.signWithContent(content: jsonStr, salt: salt)
        let signContent: String = "nice-sign-v1://" + sign + ":" + salt + "/" + jsonStr
        requeseParameters.removeAll()
        let signData: Data = signContent.data(using: .utf8) ?? Data()
        requeseParameters["data"] = signData
        return requeseParameters
    }
}
