//
//  VTWKWebViewJavascriptBridge.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/7.
//  Copyright © 2022 macos. All rights reserved.
//

import UIKit
import WebKit

class VTWKWebViewJavascriptBridge: NSObject,WKNavigationDelegate {
    
    typealias JBResponseCallback = (AnyObject) -> ()
    typealias JBHander = (AnyObject,JBResponseCallback) -> ()
    
}
