//
//  VTOpenURLContext.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/13.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

enum VTOpenURLContextState: Int {
    case VTOpenURLContextStateInit = 0
    case VTOpenURLContextStateStart
    case VTOpenURLContextStateFinish
    case VTOpenURLContextStateFailed
    case VTOpenURLContextStateCancel
}

enum VTOpenURLContextInvokeSource: Int {
    case VTOpenURLContextInvokeSourceInApp = 0
    case VTOpenURLContextInvokeSourceThirdAPP
}

class VTOpenURLContext: NSObject {

    // Notification
    let VTOpenURLContextDidFinishNotification: String = "VTOpenURLContextDidFinishNotification"
    let VTOpenURLContextDidFaildNotification: String = "VTOpenURLConetxtDidFaildNotification"
    let VTOpenURLContextDidCancelNotification: String = "VTOpenURLContextDidCancelNotification"
    let VTOpenURLContextStateWillChangeNotification: String = "VTOpenURLContextStateWillChangeNotification"
    let VTOpenURLContextStateDidChangeNotificcation: String = "VTOpenURLContextStateDidChangeNotificcation"
    
    // Error
    let VTOpenURLContextError: String = "VTOpenURLContextError"
    let VTOpenURLContextResultInfo: String = "VTOpenURLContextResultInfo"
    
    // Callback
    typealias VTOpenURLContextCallBack = (_ context: VTOpenURLContext?,_ result:Int?,_ error:Error?) ->Void
    
    // ReadOnly
    fileprivate(set) var originalURL: NSURL = NSURL.init()
    fileprivate(set) var urlParameters: Dictionary<String, Any> = [:]
    fileprivate(set) var preset: VTOpenURLPreset
    fileprivate(set) var state: VTOpenURLContextState? {
        willSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: VTOpenURLContextStateWillChangeNotification), object: state)
        }
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: VTOpenURLContextStateDidChangeNotificcation), object: state)
        }
    }
    fileprivate(set) var parameters: Dictionary<String,Any>
    {
        get {
            var tempParameters: Dictionary<String,Any> = Dictionary<String,Any>.dictionaryWithDictionary(otherDict: self.urlParameters)
            tempParameters.merge(self.extraParameters!, uniquingKeysWith: {(current,_) ->Any in current})
            return tempParameters
        }
        set {

        }
    }
    
    // Properties
    var openPageStyle: VTOpenPageStyle?
    var extraParameters: Dictionary<String, Any>?
    var sourceApplication: String?
    var invokeSource: VTOpenURLContextInvokeSource?
    var callback: VTOpenURLContextCallBack?
    
    /*
     weak 弱引用当前可选对象 仅可修饰可选对象
     unowned 类似于 OC 中的 retain、__unsafe__unratained 修饰符 同样是弱引用修饰,但是对象被释放之后,对象的引用不会自动置为nil,
     再次访问引用会崩溃
     */
    weak var manager: VTOpenURLManager?

    // MARK Public Methods
    public func start() {
        if self.manager == nil {
            self.manager = VTOpenURLManager.shared
        }
        self.setContextState(state: .VTOpenURLContextStateStart)
        self.manager?.contextDidStart(context: self)
    }
    
    public func cancel() {
        self.setContextState(state: .VTOpenURLContextStateCancel)
        self.manager?.contextDidCancel(context: self)
    }
    
    public func didFinishWithResult(result:Any) {
        self.setContextState(state: .VTOpenURLContextStateFinish)
        self.callbackWithResult(result: result, error: nil)
        self.manager?.context(context: self, didFinishResult: result)
    }
    
    public func didFailedWithError(error: Error) {
        self.setContextState(state: .VTOpenURLContextStateFailed)
        self.callbackWithResult(result: nil, error: error)
        self.manager?.context(context: self, didFailedWithError: error)
    }
    
    public func openViewController(viewController:UIViewController?,openStyle:VTOpenPageStyle,animated:Bool) {
        guard viewController != nil else {
            return
        }
        if openStyle == .VTOpenPageStyleExist {
            // 跳转已经存在的VC页面 --> 结合业务来写
            if (viewController!.presentedViewController != nil) {
                viewController?.dismiss(animated: false, completion: nil)
            }
        } else {
            let topViewController: UIViewController? = self.manager?.topViewController()
            if openStyle == .VTOpenPageStylePush {
                let navVC: UINavigationController?
                if self.manager?.appointNavigationController != nil {
                    self.manager?.appointNavigationController?.pushViewController(viewController!, animated: animated)
                    return
                }
                if topViewController is UINavigationController {
                    navVC = (topViewController as! UINavigationController)
                } else {
                    navVC = topViewController!.navigationController
                }
                navVC!.pushViewController(viewController!, animated: animated)
            } else if openStyle == .VTOpenPageStylePresent {
                if topViewController is UINavigationController {
                    topViewController?.present(viewController!, animated: animated, completion: nil)
                    return
                }
                let tempNav: VTBaseNavViewController = VTBaseNavViewController.init(rootViewController: viewController!)
                topViewController?.present(tempNav, animated: animated, completion: nil)
            } else if openStyle == .VTOpenPageStylePop {
                topViewController?.present(viewController!, animated: animated, completion: nil)
            }
        }
    }
    
    // Mark Init Methods
    required init(url:NSURL, preset:VTOpenURLPreset, parameters:Dictionary<String,Any>) {
        self.state = .VTOpenURLContextStateInit
        self.originalURL = url
        self.extraParameters = parameters
        self.preset = preset
        self.openPageStyle = preset.openPageStyle
        super.init()
        self.urlParameters = self.parseParameters(url: url,preset: preset)
    }
    
    deinit {
        printLog("DELLOC : ",self.description)
    }
}

extension VTOpenURLContext {
    // MARK Private Methods
    func parseParameters(url:NSURL,preset:VTOpenURLPreset) -> Dictionary<String,Any> {
        var urlPathParameters = url.absoluteString!.queryDictionary()
        let urlPathComponents = VTOpenURLComponents.init(componentsUrl: url)?.pathComponents
        for (index,tempObj) in preset.pathComponents!.enumerated() {
            guard tempObj.hasPrefix(":") else {
                break
            }
            let key = tempObj.substringFromIndex(index: index)
            let value = urlPathComponents?[index] ?? ""
            urlPathParameters[key] = value
        }
        return urlPathParameters
    }
    
    func callbackWithResult(result: Any?, error: Error?) {
        if error != nil {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: VTOpenURLContextDidFaildNotification), object: self, userInfo: [VTOpenURLContextError:error!])
        } else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: VTOpenURLContextDidFinishNotification), object: self, userInfo: (result != nil) ? [VTOpenURLContextResultInfo:result!] : nil)
        }
        if self.callback != nil {
            self.callback!(self,(result as! Int),error)
        }
    }
    
    func setContextState(state: VTOpenURLContextState) {
        willChangeValue(forKey: "state")
        self.state = state
        didChangeValue(forKey: "state")
    }
}

extension String {
    func queryDictionary() -> Dictionary<String,Any> {
        guard self.contains("?") else {
            return Dictionary<String,Any>.init()
        }
        let range: Range = self.range(of: "?")!
        let tempStr = String(self[range.upperBound...])
        let firstExplode: Array<String> = tempStr.components(separatedBy: "&")
        var returnDictionary: Dictionary<String,String> = Dictionary.init()
        for tempItem in 0 ..< firstExplode.count {
            let secondExplode = firstExplode[tempItem].components(separatedBy: "=")
            if secondExplode.count == 2 {
                returnDictionary[(secondExplode.last!).urlDecode()] = (secondExplode.first!).urlDecode()
            }
        }
        return returnDictionary
    }
}
