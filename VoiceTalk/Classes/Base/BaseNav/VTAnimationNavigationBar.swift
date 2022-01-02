//
//  VTAnimationNavigationBar.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/1.
//  Copyright © 2022 macos. All rights reserved.
//

import UIKit

class VTAnimationNavigationBar: UINavigationBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        if above_ios_11 {
            for tempView in self.subviews {
                if NSStringFromClass(tempView.classForCoder) == "_UINavigationBarContentView" {
                    tempView.frame = CGRect.init(x: 0, y: kStatusBarHeight, width: tempView.vt_width, height: tempView.vt_height)
                } else {
                    tempView.frame = CGRect.init(x: 0, y: 0, width: tempView.vt_width, height: self.vt_height)
                }
            }
        }
    }
    
    deinit {
        printLog("DELLOC ",self.description)
    }

}
