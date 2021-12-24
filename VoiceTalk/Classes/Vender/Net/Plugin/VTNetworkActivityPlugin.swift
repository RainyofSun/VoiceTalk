//
//  VTNetworkActivityPlugin.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/10.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

public final class VTNetworkActivityPlugin: PluginType {
    public typealias NetworkActivityClosure = (_ change: NetworkActivityChangeType, _ target: VTServerType) -> Void
    let networkActivityClosure: NetworkActivityClosure
    
    /// Initializes a NetworkActivityPlugin.
    public init(networkActivityClosure: @escaping NetworkActivityClosure) {
        self.networkActivityClosure = networkActivityClosure
    }
    
    // MARK: Plugin
    
    /// Called by the provider as soon as the request is about to start
    public func willSend(_ request: RequestType, target: VTServerType) {
        networkActivityClosure(.began, target)
    }
    
    /// Called by the provider as soon as a response arrives, even if the request is canceled.
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: VTServerType) {
        networkActivityClosure(.ended, target)
    }
}
