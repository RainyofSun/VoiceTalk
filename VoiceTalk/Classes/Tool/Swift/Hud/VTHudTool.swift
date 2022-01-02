//
//  VTHudTool.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/25.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTHudTool: NSObject {
    /**
     * 开始Loading
     */
    static func hudShow() {
        SwiftProgressHUD.showWait();
    }
    
    /**
     * 加载成功
     */
    static func hudLoadSuccess(text:String) {
        SwiftProgressHUD.showSuccess(text,autoClearTime: 1);
    }
    
    /**
     * 加载失败
     */
    static func hudLoadFail(text:String) {
        SwiftProgressHUD.showFail(text,autoClearTime: 1);
    }
    
    /**
     * 提示信息
     */
    static func hudAlertInfo(text:String) {
        SwiftProgressHUD.showInfo(text,autoClearTime: 1);
    }
    
    /**
     * Toast 提示信息
     */
    static func hudShowOnlyText(text:String) {
        SwiftProgressHUD.showOnlyText(text);
        hidHud();
    }
    
    /**
     * 状态栏提示信息
     */
    static func hudStatusBar(text:String) {
        SwiftProgressHUD.showOnNavigation(text,autoClearTime: 1);
    }
    
    /**
     * 加载动画提示
     */
    static func huaShowAnimationImg(imgName:String,imgCount:NSInteger) {
        let animationDuration = 70;
        var loadingImages = [UIImage]()
        for index in 0...imgCount {
            let loadImageName = String(format: "%@%d", imgName,index);
            if let loadImage = UIImage(named: loadImageName){
                loadingImages.append(loadImage)
            }
        }
        SwiftProgressHUD.showAnimationImages(loadingImages, timeMilliseconds: animationDuration);
    }
    
    /**
     * 隐藏HUD
     */
    static func hidHud() {
        SwiftProgressHUD.hideAllHUD();
    }
}
