//
//  VTNetWorkStatusManager.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/9.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit
import Alamofire

public enum VTNetworkStatus {
    case unknown
    case norReachable
    case reachableViaWiFi
    case reachableViaWWAN
}

class VTNetWorkStatusManager: NSObject {
    static let shared = VTNetWorkStatusManager()
    private override init() {}
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host:"www.apple.com")
    var networkStaus : VTNetworkStatus {
        guard let status = reachabilityManager?.status else { return .unknown }
        switch status {
        case .unknown:
            return VTNetworkStatus.unknown
        case .notReachable:
            return VTNetworkStatus.norReachable
        case .reachable(.ethernetOrWiFi):
            return VTNetworkStatus.reachableViaWiFi
        case .reachable(.cellular):
            return VTNetworkStatus.reachableViaWWAN
        }
    }
    
    var isReachableOnWWAN : Bool {return networkStaus == .reachableViaWWAN}
    var isReachableOnWiFi: Bool {return networkStaus == .reachableViaWiFi}
    
    func startNetworkReachabilityObserver() {
        reachabilityManager?.startListening(onQueue: .main, onUpdatePerforming: { status in
            switch status {
            case .notReachable:
                printLog("The network is not reachable")
            case .unknown:
                printLog("It is unknown whether the network is reachable")
            case .reachable(.ethernetOrWiFi):
                printLog("The network is reachable over the WiFi connection")
            case .reachable(.cellular):
                printLog("The network is reachable over the WWAN connection")
            }
            NotificationCenter.default.post(name: .networkStatusChange, object: self.networkStaus)
        })
    }
}

extension Notification.Name {
    static let networkStatusChange = Notification.Name("networkStatusChange")
}
