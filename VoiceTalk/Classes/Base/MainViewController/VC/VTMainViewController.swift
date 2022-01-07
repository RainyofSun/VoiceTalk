//
//  VTMainViewController.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/15.
//  Copyright © 2021 macos. All rights reserved.
//
/*
 // 有参数无返回值的
 typealias Myclosure1 = (String) ->Void
 // 有参数无返回值的
 typealias Myclosure2=(String) ->String
 // 两个参数,一个返回值
 typealias Myclosure3=(String, String)->String
 // 无参数，无返回值
 typealias Myclosure4=()->Void
 */
import UIKit

class VTMainViewController: UIViewController {
    let mainVM = VTMainViewModel();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 开始网络监测
        VTNetWorkStatusManager.shared.startNetworkReachabilityObserver()
        loadTabbarController();
        self.mainVM.loginExpirOrNot();
        addUserGuideView();
        self.view.backgroundColor = UIColor.red
        // Do any additional setup after loading the view.
//        let lab = UILabel.init();
//        lab.text = LanguageTool.language(key: "我知道了");
//        lab.textColor = mainColor;
//        self.view.addSubview(lab);
//        lab.snp.makeConstraints { (make) in
//            make.center.equalTo(self.view);
//        }
        
//        testStr()
//        testDict()
//        commonInit()
        testRedPoint()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.mainVM.checkAppVersion();
//        commonReques()
//        testRoute()
    }
    
    func commonReques() {
        
//        let username = "chensx1993".urlEscaped
//        let url = "users/\(username)"
//        let parameters = ["sort": "pushed"]
//
//        VTRequest.post(url, parameters: parameters, callbackQueue: .main, progress: nil) { response in
//            do {
//                let json = try response.mapJSON()
//                printLog("test post \(url): \(json)");
//
//            } catch(let error) {
//                printLog("error: \(error)");
//            }
//        } failure: { error in
//            printLog("error: \(error)");
//        }
        
//        let url1 = "toutiao/index"
//        let parameters1:[String:Any] = ["page": "1","page_size":20,"type":"top","key":"1556e6a8727672ced0deb4007782429c"]
//        VTRequest.get(url1, parameters: parameters1, callbackQueue: DispatchQueue.main, progress: { (progress) in
//
//        }, success: { (response) in
//            do {
//                let json = try response.mapJSON()
//                print("test post \(url): \(json)");
//
//            } catch(let error) {
//                print("error: \(error)");
//            }
//        }) { (error) in
//            print("error: \(error)");
//        }
    }
    
    deinit {
        printLog(String(format: "%@", self));
    }
    
    private func addUserGuideView() {
        if !mainVM.showUserGuideView() {
            printLog("不是新用户");
            return;
        }
        let guideVC = AppGuideAnimationViewController();
        self.view.addSubview(guideVC.view);
        self.addChild(guideVC);
        guideVC.switchVC = {
            guideVC.view.removeFromSuperview();
            guideVC.removeFromParent();
            Defaults[\.isNewUser] = false;
        };
    }
    
    private func loadTabbarController() {
        let tabbar = VTTabbarViewController();
        self.view.addSubview(tabbar.view);
        self.addChild(tabbar);
        tabbar.view.snp.makeConstraints { (make) in
            make.left.bottom.right.top.equalToSuperview();
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension VTMainViewController {
    func testStr() {
//        var str = "htsps://www.baidu.com?uid=888&index=10"
//        printLog(str.substringFromIndex(index: 5))
//        printLog(str.substringToIndex(index: 4))
//        var str = "天空上有美丽的星球" // 上有美丽
//        printLog(str.substringWithRange(loc: 2, len: 4))
//        guard str.contains("?") else {
//            printLog("ssss")
//            return
//        }
//        let range: Range = str.range(of: "?")!
//        str = String(str[range.upperBound...])
//        printLog(str)
    }
    func testDict() {
        let dict1 = ["1":1,"2":2]
        let dict2 = Dictionary<String, Any>.dictionaryWithDictionary(otherDict: dict1)
        printLog(dict2)
    }
    
    func commonInit() {
        let path: String = Bundle.main.path(forResource: "OpenURLPlist", ofType: "plist")!
        let list = NSDictionary(contentsOfFile: path)
        printLog(list as Any)
    }
    
    func testRoute() {
//        VTOpenURLManager.shared.openURL(url: NSURL.init(string: "nice://phoneLogin")!, callback: nil)
        VTOpenURLManager.shared.openURL(url: NSURL.init(string: "nice://phoneLogin")!, openStyle: .VTOpenPageStylePush, parameters: nil, callback: nil)
    }
    
    func testRedPoint() {
        let redPoint = VTRedPointLabel.init(position: CGPoint.init(x: 100, y: 100))
        redPoint.text = "1"
        self.view.addSubview(redPoint)
        vt_dispatch_after_block(time: .now() + 2) {
            redPoint.text = "0"
        }
    }
}
