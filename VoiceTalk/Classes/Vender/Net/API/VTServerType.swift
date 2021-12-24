//
//  VTServerType.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/9.
//  Copyright © 2021 macos. All rights reserved.
//

import Foundation
import Moya

public typealias VTHTTPMethod = Moya.Method;
public typealias VTValidationType = Moya.ValidationType;
public typealias VTSampleResponse = Moya.EndpointSampleResponse;
public typealias VTStubBehavihor  = Moya.StubBehavior;

public protocol VTServerType : TargetType {
    var showLoading : Bool {get}
    var parameters : [String:Any]? {get}
    var stubBehavior : VTStubBehavihor {get}
    var sampleResponse : VTSampleResponse {get}
}

extension VTServerType {
    public var base : String {return VTServer.shared.rootUrl}
    public var baseURL: URL {return URL(string: base)!}
    public var headers : [String : String]? {return VTServer.shared.headers}
    public var parameters : [String : Any]? {return VTServer.shared.parameters}
    public var showLoading : Bool {return false}
    
    public var task: Task {
        let encoding : ParameterEncoding
        switch self.method {
        case.post:
            encoding = JSONEncoding.default
        default:
            encoding = URLEncoding.default
        }
        if let requestParameters = parameters {
            return .requestParameters(parameters: requestParameters, encoding: encoding);
        }
        return .requestPlain
    }
    
    public var method: VTHTTPMethod {
        return .post
    }
    
    public var validationType: VTValidationType {
        return .successCodes
    }
    
    public var stubBehavior : VTStubBehavihor {
        return .never
    }
    
    public var sampleData: Data {
        return "response : test data".data(using: String.Encoding.utf8)!
    }
    
    public var sampleResponse: VTSampleResponse {
        return .networkResponse(200, self.sampleData)
    }
}

func VTBaseUrl(_ path:String) -> String {
    if path.isCompleteUrl {return ""}
    return path;
}

func VTPath(_ path: String) -> String {
    if path.isCompleteUrl { return "" }
    return path;
}

extension String {
    var isCompleteUrl: Bool {
        let scheme = self.lowercased();
        return scheme.contains("http");
    }
}

