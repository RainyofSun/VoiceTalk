//
//  VTStringSize.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/24.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

extension String {
    
    // 默认多加 6 pt 宽度
    func textWidth(font: UIFont,constraintHeight:CGFloat? = CGFloat(MAXFLOAT)) -> CGFloat {
        return textSize(font: font, constraintHegiht: constraintHeight).width + 6
    }
    
    // 默认多加 1pt 高度
    func textHeight(font: UIFont,constraintWidth:CGFloat? = CGFloat(MAXFLOAT)) -> CGFloat {
        return textSize(font: font, constraintWidth: constraintWidth).height + 1
    }
    
    func textSize(font: UIFont, constraintWidth: CGFloat? = CGFloat(MAXFLOAT), constraintHegiht:CGFloat? = CGFloat(MAXFLOAT)) -> CGSize {
        let textSize: CGSize = self.boundingRect(with: CGSize.init(width: constraintWidth!, height: constraintHegiht!), options: .usesLineFragmentOrigin, attributes: [.font:font], context: nil).size
        return textSize
    }
}
