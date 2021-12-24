//
//  VTOpenURLManager.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/13.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTOpenURLManager: NSObject {
    
    // MARK 只读属性
    fileprivate(set) var schemes: Array<String> = []
    fileprivate(set) var webHosts: Array<String> = []

    // MARK 属性
    // 解决topViewController获取不到模态的navigationController进行push的问题
    var appointNavigationController: UINavigationController?
    
    private var presets: Array<VTOpenURLPreset> = []
    private var contexts: Array<VTOpenURLContext> = []
    
    // Callback
    typealias VTOpenURLContextCallBack = (_ context: VTOpenURLContext?,_ result:Int?,_ error:Error?) ->Void
    
    // MARK public methods
    public func canOpenURL(url: NSURL) -> Bool {
        return self.presetWithURL(url: url) != nil
    }
    
    @discardableResult public func openURL(url: NSURL,callback: VTOpenURLContextCallBack?) -> VTOpenURLContext? {
        return self.openURL(url: url, parameters: nil, callback: callback)
    }
    
    @discardableResult public func openURL(url: NSURL,targetView: UIView,callback: VTOpenURLContextCallBack?) -> VTOpenURLContext? {
        return self.openURL(url: url, parameters: [:], callback: callback)
    }
    
    @discardableResult public func openURL(url: NSURL, parameters: Dictionary<String,Any>?, callback:VTOpenURLContextCallBack?) -> VTOpenURLContext? {
        let tempParameters: Dictionary = url.absoluteString!.queryDictionary()
        var isDialogTheme: Bool = false
        if tempParameters.keys.contains("dialogtheme") {
            isDialogTheme = tempParameters["dialogtheme"] as! Bool
        }
        var openStyle: VTOpenPageStyle = .VTOpenPageStyleDefault
        // h5半屏展示
        if isDialogTheme {
            openStyle = .VTOpenPageStylePop
        }
        return self.openURL(url: url, openStyle: openStyle, parameters: parameters, callback: callback)
    }

    @discardableResult public func openURL(url: NSURL, parameters: Dictionary<String,Any>?, targetView: UIView, callback:VTOpenURLContextCallBack?) -> VTOpenURLContext? {
        return self.openURL(url: url, openStyle: .VTOpenPageStyleDefault, parameters: parameters, callback: callback)
    }
    
    @discardableResult public func openURL(url: NSURL,openStyle: VTOpenPageStyle,parameters: Dictionary<String,Any>?, callback:VTOpenURLContextCallBack?) -> VTOpenURLContext? {
        return self.openURL(url: url, style: openStyle, sourceApplication: nil, parameters: parameters, callback: callback)
    }
    
    @discardableResult public func openURL(url: NSURL,sourceApplication: String?,parameters: Dictionary<String,Any>?, callback: VTOpenURLContextCallBack?) -> VTOpenURLContext? {
        return self.openURL(url: url, style: .VTOpenPageStyleDefault, sourceApplication: sourceApplication, parameters: parameters, callback: callback)
    }

    @discardableResult public func openPageNamed(pageName: String,targetView: UIView,parameters: Dictionary<String,Any>,callback: VTOpenURLContextCallBack?) -> VTOpenURLContext? {
        return self.openPageNamed(pageName: pageName, parameters: parameters, callback: callback)
    }
    
    @discardableResult public func openPageNamed(pageName: String,parameters: Dictionary<String,Any>, callback: VTOpenURLContextCallBack?) -> VTOpenURLContext? {
        guard pageName.count != 0 else {
            return nil
        }
        return self.openURL(url: NSURL.init(string: "nice://" + pageName)!, parameters:parameters,callback: callback)
    }
    
    public func contextDidStart(context: VTOpenURLContext) {
        self.contexts.append(context)
    }
    
    public func context(context: VTOpenURLContext, didFinishResult: Any) {
        self.contexts.removeAll(where: {$0 == context})
    }
    
    public func context(context: VTOpenURLContext, didFailedWithError: Error) {
        self.contexts.removeAll(where: {$0 == context})
    }
    
    public func contextDidCancel(context: VTOpenURLContext) {
        self.contexts.removeAll(where: {$0 == context})
    }
    
    public func topViewController() -> UIViewController? {
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel.rawValue != 0 {
            let windows = UIApplication.shared.windows
            for tempWindow in windows {
                if tempWindow.windowLevel.rawValue == 0 {
                    window = tempWindow
                    break
                }
            }
        }
        let vc = window?.rootViewController
        return self.getTopVC(currentVC: vc)
    }
    
    public func getTopVC(currentVC: UIViewController?) -> UIViewController? {
        if currentVC == nil {
            return nil
        }
        if let presetVC = currentVC?.presentedViewController {
            return self.getTopVC(currentVC: presetVC)
        } else if let tabVC = currentVC as? UITabBarController {
            if let selectVC = tabVC.selectedViewController {
                return self.getTopVC(currentVC: selectVC)
            }
            return nil
        } else if let navVC = currentVC as? UINavigationController {
            return self.getTopVC(currentVC: navVC.visibleViewController)
        } else if currentVC is VTMainViewController {
            return self.getTopVC(currentVC: currentVC?.children.first)
        } else {
            return currentVC
        }
    }
    
    public func existViewControllerWithClass(controllerClass:AnyClass) -> UIViewController? {
        return self.viewControllerWithClass(controllerClass: controllerClass, controller: UIApplication.shared.keyWindow?.rootViewController)
    }
    
    static let shared = VTOpenURLManager()
    private override init() {
        super.init()
        commonInit()
    };

}

extension VTOpenURLManager {
    func commonInit() {
        let boundlePath: String = Bundle.main.path(forResource: "OpenURLPlist", ofType: "plist")!
        let list = NSDictionary(contentsOfFile: boundlePath)
        self.webHosts = list?.value(forKey: "webhosts") as! Array<String>
        self.schemes = list?.value(forKey: "schemes") as! Array<String>
        let path: Dictionary<String,Dictionary<String, String>> = list?.value(forKeyPath: "paths") as! Dictionary<String,Dictionary<String, String>>
        self.presets.removeAll()
        for (key,value) in path {
            let preset = VTOpenURLPreset.presentWithPath(path: key, presentData: value)
            self.presets.append(preset)
        }
    }
    
    func presetWithURL(url: NSURL) -> VTOpenURLPreset? {
        guard let components: VTOpenURLComponents = VTOpenURLComponents.init(componentsUrl: url) else {
            return nil
        }
        for tempPreset in self.presets {
            if tempPreset.validateURLComponents(urlComponents: components) {
                return tempPreset
            }
        }
        return nil
    }
    
    func openURL(url: NSURL, style: VTOpenPageStyle, sourceApplication: String?, parameters: Dictionary<String,Any>?, callback:VTOpenURLContextCallBack?) -> VTOpenURLContext? {
        let tempUrl = self.filterURL(url: url)
        if tempUrl.scheme?.count == 0 || tempUrl.host?.count == 0 {
            if UIApplication.shared.canOpenURL(tempUrl as URL) {
                UIApplication.shared.openURL(tempUrl as URL)
                return nil
            }
            guard callback != nil else {
                return nil
            }
            let error = NSError.init(domain: VTOpenURLErrorDomain, code: VTOpenURLError.VTOpenURLBadURLError.rawValue, userInfo: [NSLocalizedDescriptionKey:"无效URL"])
            callback!(nil,nil,error as Error)
            return nil
        }
        
        guard let present = self.presetWithURL(url: tempUrl) else {
            if (tempUrl.scheme?.contains("http"))! as Bool {
                if tempUrl.host! == "itunes.apple.com" {
                    UIApplication.shared.openURL(tempUrl as URL)
                    return nil
                }
                var tempDict:Dictionary<String,Any> = Dictionary<String, Any>.dictionaryWithDictionary(otherDict: parameters ?? Dictionary<String,String>.init())
                var queryString = self.queryStringFromDict(dict: tempDict, originalUrl: tempUrl.absoluteString!)
                if queryString.count != 0 {
                    tempDict["url"] = tempUrl.absoluteString! + queryString
                } else {
                    tempDict["url"] = tempUrl.absoluteString!
                }
                return self.openURL(url: NSURL.init(string: "nice://openweb")!, style: style, sourceApplication: sourceApplication, parameters: tempDict, callback: callback)
            }
            // 打开自定义的url
            if UIApplication.shared.canOpenURL(tempUrl as URL) {
                UIApplication.shared.openURL(tempUrl as URL)
                return nil
            }
            guard callback != nil else {
                return nil
            }
            let error = NSError.init(domain: VTOpenURLErrorDomain, code: VTOpenURLError.VTOpenURLNoContextError.rawValue, userInfo: [NSLocalizedDescriptionKey:"没有找到预置"])
            callback!(nil,nil,error as Error)
            return nil
        }
        let context: VTOpenURLContext!
        if let type = present.contextClass! as? VTOpenURLContext.Type {
            context = type.init(url: tempUrl, preset: present, parameters: parameters ?? [:])
        } else {
            context = VTOpenURLContext.init(url: tempUrl, preset: present, parameters: parameters ?? [:])
        }
        if style != .VTOpenPageStyleDefault {
            context.openPageStyle = style
        }
        if sourceApplication != nil {
            context.sourceApplication = sourceApplication
            context.invokeSource = .VTOpenURLContextInvokeSourceThirdAPP
        } else {
            context.invokeSource = .VTOpenURLContextInvokeSourceInApp
        }
        context.manager = self
        context.start()
        return context
    }
    
    func queryStringFromDict(dict: Dictionary<String,Any>, originalUrl:String) -> String {
        let hasContainParameters: Bool = originalUrl.contains("?")
        var tempStr: String = ""
        if dict.keys.count > 0 {
            var index: Int = 0
            dict.forEach { (tempKey,tempValue) in
                var part: String = ""
                let value = tempValue as! String
                if index == 0 && !hasContainParameters {
                    part = "?" + tempKey + "=" + value
                } else {
                    part = "&" + tempKey + "=" + value
                }
                tempStr.append(part)
                index = index + 1
            }
        }
        return tempStr
    }
    
    func filterURL(url: NSURL) -> NSURL {
        guard url.absoluteString!.contains("slide_discover") else {
            return url
        }
        let tempDict: Dictionary<String,Any> = url.absoluteString!.queryDictionary()
        guard let pageType: String = tempDict["page_type"] as? String else { return url }
        var tempStr = url.absoluteString!
        tempStr = tempStr.replacingOccurrences(of: "slide_discover", with: pageType)
        return NSURL.init(string: tempStr) ?? url
    }
    
    func viewControllerWithClass(controllerClass: AnyClass?, controller: UIViewController?) -> UIViewController? {
        guard (controller != nil) && (controllerClass != nil) else {
            return nil
        }
        guard controller!.isKind(of: controllerClass!) else {
            return controller
        }
        if controller! is UINavigationController {
            let tempNav:UINavigationController = controller as! UINavigationController
            for tempVC in tempNav.viewControllers {
                let tempViewController: UIViewController? = self.viewControllerWithClass(controllerClass: controllerClass, controller: tempVC)
                if (tempViewController != nil) {
                    return tempViewController
                }
            }
        } else if controller! is UITabBarController {
            let tempTabbar: UITabBarController = controller as! UITabBarController
            for tempVC in tempTabbar.viewControllers! {
                let tempViewController = self.viewControllerWithClass(controllerClass: controllerClass, controller: tempVC)
                if tempViewController != nil {
                    return tempViewController
                }
            }
        }
        return nil
    }
}

extension UIViewController {
    // 是否可以打开新的界面 default = YES
    func VTCanOpenNewPage() -> Bool {
        return true
    }
}
