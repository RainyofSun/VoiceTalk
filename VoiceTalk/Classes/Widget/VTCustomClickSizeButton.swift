//
//  VTCustomClickSizeButton.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/4.
//  Copyright © 2022 macos. All rights reserved.
//

import UIKit

class VTCustomClickSizeButton: UIButton {

    // 按钮的点击大小，如果小于按钮本身大小则无效
    open var clickSize: CGSize? = CGSize.zero
    open var cancelHighLight: Bool? = false
    override var isHighlighted: Bool {
        willSet {
            if !self.cancelHighLight! {
                self.isHighlighted = newValue
            }
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        var maxClickSize: CGSize = .zero
        if self.clickSize!.width != 0 && self.clickSize!.height != 0 {
            maxClickSize = self.clickSize!
        } else {
            maxClickSize = CGSize.init(width: self.vt_width * 2, height: self.vt_height * 2)
        }
        let widthDefect: CGFloat = max(maxClickSize.width - self.vt_width, 0)
        let heightDefect: CGFloat = max(maxClickSize.height - self.vt_height, 0)
        let tempBounds: CGRect = self.bounds.insetBy(dx: -0.5 * widthDefect, dy: -0.5 * heightDefect)
        return tempBounds.contains(point)
    }
    
    deinit {
        printLog("DELLOC ",self.description)
    }
}
