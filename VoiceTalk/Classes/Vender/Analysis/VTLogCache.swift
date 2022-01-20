//
//  VTLogCache.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/19.
//  Copyright © 2022 macos. All rights reserved.
//

import UIKit

class VTLogCache: NSObject {

    private var logName: String?
    private var logs: NSMutableArray?
    private var autoSend: Bool = true
    private var isSendingLog: Bool = false
    private var maxSize: Int?
    private var api: String?
    private let VT_MUST_UPLOAD_NUM: Int = 500
    
    init(logName: String, api: String, maxSize: Int) {
        super.init()
        self.logName = logName
        self.maxSize = maxSize
        self.api = api
        self.logs = NSMutableArray.init(array: NSArray(contentsOfFile: cachePath())!)
        self.addSystemNotification()
    }
    
    deinit {
        self.removeSystemNotification()
        printLog("DELLOC" + self.description)
    }
    
    public func addLog(log: Dictionary<String,Any>, forceSend: Bool = true) {
        self.addLog(log: log)
        if forceSend {
            appDidEnterBackground()
        }
    }
    
    public func sendCachedLogs() {
        if self.logs!.count <= 0 || self.isSendingLog {
            return
        }
        self.isSendingLog = true
        if !JSONSerialization.isValidJSONObject(self.logs!) {
            self.logs!.removeAllObjects()
            self.isSendingLog = false
            return
        }
        syncToFile()
        weak var wealSelf = self
        VTRequest.post(self.api!, parameters: ["logs":self.logs!], callbackQueue: .main, progress: nil) { response in
            VTAnalysisManager.shared.runOnIoQueue {
                wealSelf?.isSendingLog = false
                if wealSelf?.logs?.count ?? 0 > wealSelf!.VT_MUST_UPLOAD_NUM {
                    wealSelf?.clearCache()
                }
            }
        } failure: { error in
            
        }
    }
}

extension VTLogCache {
    func cachePath() -> String {
        return NSLibraryFolder() + "/\(self.logName!)"
    }
    
    func addSystemNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    func removeSystemNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addLog(log: Dictionary<String,Any>) {
        if !JSONSerialization.isValidJSONObject(log) {
            return
        }
        self.logs!.add(log)
        if self.logs!.count > self.maxSize!  {
            if self.autoSend {
                sendCachedLogs()
            } else {
                self.logs!.removeObject(at: 0)
            }
        }
    }
    
    func syncToFile() {
        if JSONSerialization.isValidJSONObject(self.logs!) {
            self.logs!.write(toFile: cachePath(), atomically: true)
        }
    }
    
    func clearCache() {
        self.logs!.removeAllObjects()
        do {
            try FileManager.default.removeItem(atPath: cachePath())
        } catch let error as NSError {
            printLog("删除缓存log 错误" + error.localizedDescription)
        }
    }
    
    @objc func appDidEnterBackground() {
        VTAnalysisManager.shared.runOnIoQueue {
            if self.autoSend {
                self.sendCachedLogs()
            } else {
                self.syncToFile()
            }
        }
    }
}
