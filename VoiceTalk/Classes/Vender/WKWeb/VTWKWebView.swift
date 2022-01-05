//
//  VTWKWebView.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/2.
//  Copyright © 2022 macos. All rights reserved.
//

/*
 Swift 指针使用 ： https://www.jianshu.com/p/ee1b9cb1e8a0
 */
import UIKit
import WebKit

class VTWKWebView: WKWebView,UIGestureRecognizerDelegate {

    private var saveImage: UIImage? = nil
    private var localLongGesture: UILongPressGestureRecognizer? = nil
    
    public func enableLocalLongGesture(enabled: Bool? = true) {
        self.localLongGesture?.isEnabled = enabled!
    }
    
    public func stringByEvaluatingJavaScriptFromString(javaScript: String, outError: UnsafeMutablePointer<NSError>) -> AnyObject? {
        var evaluateResult: AnyObject? = nil
        var finish: Bool = false
        self.evaluateJavaScript(javaScript) { result, error in
            evaluateResult = result as AnyObject?
            finish = true
            if error != nil {
                outError.pointee = error! as NSError
            }
        }
        while !finish {
            RunLoop.current.run(mode: .default, before: NSDate.distantFuture)
        }
        return evaluateResult ?? nil
    }
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        self.localLongGesture = initGestureRecognizer()
        self.addGestureRecognizer(self.localLongGesture!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        printLog("DELLOC",self.description)
    }
}

// MARK - UIGestureRecognizerDelegate
extension VTWKWebView {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension VTWKWebView {
    func initGestureRecognizer() ->UILongPressGestureRecognizer {
        let longGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(handleLonghPress(sender:)))
        longGesture.delegate = self
        longGesture.cancelsTouchesInView = true
        return longGesture
    }
    
    func fetchWindowSize(callback:@escaping (_ windowSize:CGSize)->()) {
        weak var weakSelf = self
        self.evaluateJavaScript("window.innerWidth") { data, error in
            if let strongSelf = weakSelf {
                let width: CGFloat = data as? CGFloat ?? 0
                strongSelf.evaluateJavaScript("window.innerHeight") { heightData, error in
                    let height: CGFloat = heightData as? CGFloat ?? 0
                    let size: CGSize = CGSize.init(width: width, height: height)
                    callback(size)
                }
            }
        }
    }
    
    func findImageOfTheSpecialLocation(point: CGPoint) {
        // Load the JavaScript code from the Resources and inject it into the web page
        let filePath: String = Bundle.main.path(forResource: "JS_GetSelected", ofType: "js")!
        var jsCode: String? = nil
        do {
            jsCode = try String.init(contentsOfFile: filePath, encoding: String.Encoding.utf8)
        } catch let err as NSError {
            printLog(err.localizedDescription)
        }
        
        weak var weakSelf = self
        guard jsCode != nil else {
            printLog("JSCode nil")
            return
        }
        self.evaluateJavaScript(jsCode!) { data, error in
            if error != nil {
                return
            }
            if let strongSelf = weakSelf {
                let imgSrcAtPoint: String = String(format: "GetImgSrcAtPoint(%f,%f);", point.x,point.y)
                strongSelf.evaluateJavaScript(imgSrcAtPoint) { str, errorSrc in
                    if errorSrc != nil {
                        return
                    }
                    let imageStr: String = String(format: "%@", str as! CVarArg)
                    var data: Data? = nil
                    do {
                        data = try Data.init(contentsOf: URL.init(string: imageStr)!)
                    } catch let catchError as NSError {
                        printLog("Catch Error" + catchError.localizedDescription)
                    }
                    guard data != nil else {
                        return
                    }
                    if let innerStrongSelf = weakSelf {
                        if let image: UIImage = UIImage.init(data: data!) {
                            innerStrongSelf.saveImage = image
                            // TODO 保存图片到相册
                            innerStrongSelf.writeImageToAlbum()
                        }
                    }
                }
            }
        }
    }
    
    func writeImageToAlbum() {
        DispatchQueue.main.async {
            UIImageWriteToSavedPhotosAlbum(self.saveImage!, self, #selector(self.saveImage(img:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    @objc func saveImage(img: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil {
            printLog("保存照片失败")
        } else {
            printLog("已保存到系统相册")
        }
    }
}

// MARK - Action
extension VTWKWebView {
    @objc func handleLonghPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            var locationInSelf: CGPoint = sender.location(in: self.superview)
            let viewSize: CGSize = self.vt_size
            weak var weakSelf = self
            self.fetchWindowSize { windowSize in
                if let strongSelf = weakSelf {
                    let f: CGFloat = windowSize.width/viewSize.width
                    locationInSelf.x = locationInSelf.x * f
                    locationInSelf.y = locationInSelf.y * f
                    strongSelf.findImageOfTheSpecialLocation(point: locationInSelf)
                }
            }
        }
    }
}
