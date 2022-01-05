//
//  VTNODataLabel.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/4.
//  Copyright © 2022 macos. All rights reserved.
//

import UIKit

class VTNODataLabel: UILabel {

    init(text:String) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: screen_width, height: 100))
        self.backgroundColor = VTClearColor
        self.font = VTNormalFont15
        self.textColor = RGBCOLOR(r: 102.0, 102.0, 102.0, 1)
        self.text = text
        self.textAlignment = .center
        self.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        printLog("DELLOC",self.description)
    }

}
