//
//  VTNavigationTitleView.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/5.
//  Copyright © 2022 macos. All rights reserved.
//

import UIKit

class VTNavigationTitleView: UILabel {

    public func refreshTitle(title: String) {
        let center: CGPoint = self.center
        self.text = title
        self.sizeToFit()
        self.center = center
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = VTClearColor
        self.font = VTNormalFont17
        self.textAlignment = .center
        self.sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        printLog("DELLOC ", self.description)
    }

}
