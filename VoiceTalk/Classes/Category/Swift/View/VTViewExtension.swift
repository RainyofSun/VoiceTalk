//
//  VTViewExtension.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/24.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

extension UIView {
    var vt_width: CGFloat {
        get {
            return self.bounds.size.width
        }
        set(width) {
            self.frame.size = CGSize(width: width, height: self.frame.height)
        }
    }
    
    var vt_height: CGFloat {
        get {
            return self.bounds.size.height
        }
        set(height) {
            self.frame.size = CGSize.init(width: self.frame.width, height: height)
        }
    }
    
    var vt_left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(leftX) {
            self.frame.origin = CGPoint.init(x: leftX, y: self.frame.origin.y)
        }
    }
    
    var vt_right: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(rightX) {
            self.frame.origin = CGPoint.init(x: (rightX - self.vt_width), y: self.frame.origin.y)
        }
    }
    
    var vt_top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(topY) {
            self.frame.origin = CGPoint.init(x: self.frame.origin.x, y: topY)
        }
    }
    
    var vt_bottom: CGFloat {
        get {
            return self.frame.origin.y + self.vt_height
        }
        set (bottomY) {
            self.frame.origin = CGPoint.init(x: self.vt_left, y: (bottomY - self.vt_height))
        }
    }
    
    var vt_size: CGSize {
        get {
            return self.bounds.size
        }
    }
    
    var vt_center_x: CGFloat {
        get {
            return self.vt_left + self.vt_size.width * 0.5
        }
        set(centerX) {
            self.center = CGPoint.init(x: centerX, y: self.center.y)
        }
    }
    
    var vt_center_y: CGFloat {
        get {
            return self.vt_top + self.vt_height * 0.5
        }
        set (centerY) {
            self.center = CGPoint.init(x: self.center.x, y: centerY)
        }
    }
    
    var vt_half_width: CGFloat {
        get {
            return self.vt_width * 0.5
        }
    }
    
    var vt_half_height: CGFloat {
        get {
            return self.vt_height * 0.5
        }
    }
}
