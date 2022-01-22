//
//  VTAnalysisReportNetManager.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/21.
//  Copyright © 2022 macos. All rights reserved.
//

import UIKit

class VTAnalysisReportNetManager: NSObject {

    static let shared = VTAnalysisReportNetManager();
    private override init() {}
    
    // Callback
    typealias VTAnalysisReportCallback = (_ clearCache: Bool) ->Void
    
    public func vtAnalysisReport(logs:Dictionary<String,Any>,analysisReportCallback callback: @escaping VTAnalysisReportCallback) {
        /**
         请求链接
         */
        let linkStr = LogServiceAddress + "app"
        /**
         创建请求的URL
         */
        let url = URL.init(string: linkStr)
        /**
         创建请求载体
         */
        var request = URLRequest.init(url: url!)
        /**
         设置请求的类型
         */
        request.httpMethod = "POST"
        /**
         请求头
         */
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        /**
         设置请求的Boby体
         */
        request.httpBody = try! JSONSerialization.data(withJSONObject: logs, options: .prettyPrinted)
        /**
         可以发起请求
         */
        let postTask = URLSession.shared.dataTask(with: request) { ( data, response, error) in
            callback(error == nil)
        }
        /**
         开始挂起
         */
        postTask.resume()
    }
}
