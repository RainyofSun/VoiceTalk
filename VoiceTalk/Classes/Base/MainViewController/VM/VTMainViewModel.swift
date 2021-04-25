//
//  VTMainViewModel.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/25.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

// token过期时间
let toeknExpireTime: NSInteger = 5400000;

class VTMainViewModel: VTBaseViewModel {
    /**
     * 展示新手引导
     */
    open func showUserGuideView() -> Bool {
        return Defaults[\.isNewUser];
    }
    
    /**
     * 判断登录是否过期
     */
    open func loginExpirOrNot(vc: UIViewController) {
        
    }
    
    /**
     * 检测版本更新
     */
    open func checkAppVersion() {
        
    }
}
