//
//  VTBarButtonItem.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/4.
//  Copyright © 2022 macos. All rights reserved.
//

import UIKit

class VTBarButtonItem: UIBarButtonItem {
    
    class func backButtomItem(clicked: @escaping UIControlClickedListener) -> VTBarButtonItem {
        let tempItem: VTBarButtonItem = VTBarButtonItem.leftItemWithImageName(imageName: "", clicked: clicked)
        if above_ios_11 {
            let tempBtn: VTCustomClickSizeButton = tempItem.customView as! VTCustomClickSizeButton
            tempBtn.frame = CGRect.init(x: 0, y: 0, width: 64, height: 64)
            tempBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -52, bottom: 0, right: 0)
        }
        return tempItem;
    }
    
    class func shareButtonItem(clicked: @escaping UIControlClickedListener) -> VTBarButtonItem {
        return VTBarButtonItem.rightItemWithImageName(imageName: "", clicked: clicked)
    }
    
    class func storyPublishBackButtonItem(clicked: @escaping UIControlClickedListener) -> VTBarButtonItem {
        let tempItem: VTBarButtonItem = VTBarButtonItem.leftItemWithImageName(imageName: "", clicked: clicked)
        if above_ios_11 {
            let tempBtn: VTCustomClickSizeButton = tempItem.customView as! VTCustomClickSizeButton
            tempBtn.frame = CGRect.init(x: 0, y: 0, width: 64, height: 64)
            tempBtn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -52, bottom: 0, right: 0)
        }
        return tempItem;
    }
    
    class func rightItemWithImageName(imageName: String, clicked: @escaping UIControlClickedListener) -> VTBarButtonItem {
        let button: VTCustomClickSizeButton = VTCustomClickSizeButton(type: .custom)
        button.setImage(UIImage.init(named: imageName), for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 18, height: 22)
        button.setOnClickedListener(listener: clicked)
        button.sizeToFit()
        let tempItem: VTBarButtonItem = VTBarButtonItem.init(customView: button)
        return tempItem
    }
    
    class func leftItemWithImageName(imageName: String, clicked: @escaping UIControlClickedListener) -> VTBarButtonItem {
        let button: VTCustomClickSizeButton = VTCustomClickSizeButton(type: .custom)
        button.setImage(UIImage.init(named: imageName), for: .normal)
        button.frame = CGRect.init(x: 0, y: 0, width: 12, height: 22)
        button.clickSize = CGSize.init(width: 100, height: 64)
        button.setOnClickedListener(listener: clicked)
        button.sizeToFit()
        let tempItem: VTBarButtonItem = VTBarButtonItem.init(customView: button)
        return tempItem
    }
    
    class func buttonWithTitle(title: String, contentEdageInsets:UIEdgeInsets = UIEdgeInsets.zero, target: AnyObject, action: Selector) -> VTBarButtonItem {
        let tempButton: VTCustomClickSizeButton = VTCustomClickSizeButton(type: .custom)
        tempButton.setTitle(title, for: .normal)
        tempButton.setTitleColor(VTBlackColor, for: .normal)
        tempButton.setTitleColor(VTGrayColor, for: .disabled)
        tempButton.contentHorizontalAlignment = .right
        tempButton.titleLabel?.font = VTNormalFont15
        tempButton.frame = CGRect.init(x: 0, y: 0, width: tempButton.titleLabel!.vt_width + 5, height: 44)
        tempButton.contentEdgeInsets = contentEdageInsets
        tempButton.addTarget(target, action: action, for: .touchUpInside)
        tempButton.isExclusiveTouch = true
        return VTBarButtonItem.init(customView: tempButton)
    }
    
    class func buttonItemWithTitle(title: String, normalTitleColor: UIColor, disabledTitleColor: UIColor = VTGrayColor, titleFont: UIFont, target: AnyObject, action: Selector) -> VTBarButtonItem {
        
        let tempButton: VTCustomClickSizeButton = VTCustomClickSizeButton(type: .custom)
        tempButton.setTitle(title, for: .normal)
        tempButton.setTitleColor(normalTitleColor, for: .normal)
        tempButton.setTitleColor(disabledTitleColor, for: .disabled)
        tempButton.contentHorizontalAlignment = .right
        tempButton.titleLabel?.font = titleFont
        tempButton.frame = CGRect.init(x: 0, y: 0, width: title.textWidth(font: titleFont) + 5, height: 44)
        tempButton.addTarget(target, action: action, for: .touchUpInside)
        tempButton.isExclusiveTouch = true
        return VTBarButtonItem.init(customView: tempButton)
    }
}
