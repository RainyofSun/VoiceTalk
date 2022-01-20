//
//  VTAnalysisManager.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/19.
//  Copyright © 2022 macos. All rights reserved.
//

import UIKit

enum VTActionLogType: Int {
    case VTActionLogTypeEvent = 1
    case VTActionLogTypeLog
    case VTActionLogTypeCrash
}

class VTAnalysisManager: NSObject {
    
    private let io_queue: DispatchQueue = DispatchQueue(label: "com.nice.analysis_io_queue")
    private let defaultLogCache: VTLogCache = VTLogCache.init(logName: "log.data", api: "app", maxSize: 500)
    
    static let shared = VTAnalysisManager();
    private override init() {};
    
    public func vtLogWithAction(action: String) {
        self.vtLogWithAction(action: action, page: nil)
    }
    
    public func vtLogWithAction(action: String, page viewController: UIViewController?) {
        self.vtLogWithAction(action: action, page: viewController, extraParameters: nil)
    }
    
    public func vtLogWithAction(action: String, page viewController: UIViewController?, extraParameters parameters: Dictionary<String,Any>?) {
        var extraParameters: Dictionary<String,Any> = Dictionary<String,Any>.dictionaryWithDictionary(otherDict: parameters)
        extraParameters["vcName"] = viewController?.description ?? ""
        self.vtLogWithAction(action: action, parameters: nil, extraParameters: extraParameters)
    }
    
    public func vtLogWithAction(action: String, parameters logParameters: Dictionary<String,Any>?,  extraParameters parameters: Dictionary<String,Any>?) {
        self.vtLogWithAction(action: action, parameters: logParameters, extraParameters: parameters, logCache: self.defaultLogCache)
    }
    
    public func vtLogWithAction(action: String, parameters logParameters: Dictionary<String,Any>?, extraParameters parameters: Dictionary<String,Any>?, logCache cache: VTLogCache) {
        self.vtLogWithAction(action: action, parameters: logParameters, extraParameters: parameters, logCache: cache, syncLocalytics: true)
    }
    
    public func vtLogWithAction(action: String, parameters logParameters: Dictionary<String,Any>?, extraParameters parameters: Dictionary<String,Any>?, logCache cache: VTLogCache, syncLocalytics localytics: Bool) {
        
        vt_dispatch_main_block {
            var log: Dictionary<String,Any> = Dictionary<String,Any>.dictionaryWithDictionary(otherDict: logParameters)
            if parameters != nil {
                log["attr"] = parameters!
            }
            log["uid"] = VTGlobalStatusModel.shared.userInfoModel.userId
            log["ts"] = Date.timestampString()
            log["act"] = action
            self.addLog(log: log, logCache: cache)
        }
    }
    
    public func vtLogWithAction(action: String, parameters logParameters: Dictionary<String,Any>?, extraParameters parameters: Dictionary<String,Any>, logCache cache: VTLogCache, syncLocalytics localytics: Bool, forceSendLog sendLog: Bool) {
        vt_dispatch_main_block {
            var log: Dictionary<String,Any> = Dictionary<String,Any>.dictionaryWithDictionary(otherDict: logParameters)
            log["attr"] = parameters
            log["uid"] = VTGlobalStatusModel.shared.userInfoModel.userId
            log["ts"] = Date.timestampString()
            log["act"] = action
            self.runOnIoQueue {
                cache.addLog(log: log, forceSend: sendLog)
            }
        }
    }
    
    public func vtLogWithAction(action: String, logType type: VTActionLogType, extraParameters parameters: Dictionary<String,Any>?) {
        self.vtLogWithAction(action: action, parameters: ["lt":type], extraParameters: parameters)
    }
    
    public func runOnIoQueue(sendLog: @escaping @convention(block) () -> Void) {
        self.io_queue.async {
            sendLog()
        }
    }
}

extension VTAnalysisManager {
    func addLog(log: Dictionary<String,Any>, logCache cache: VTLogCache) {
        self.runOnIoQueue {
            cache.addLog(log: log)
        }
    }
}
