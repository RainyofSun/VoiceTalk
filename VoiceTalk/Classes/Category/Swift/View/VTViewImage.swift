//
//  VTViewImage.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/2.
//  Copyright © 2022 macos. All rights reserved.
//

import UIKit

extension UIView {
    
    func imageFromView() -> UIImage {
        return imageFromViewWithScale(scale: UIScreen.main.scale)
    }
    
    func imageFromViewWithScale(scale: CGFloat) -> UIImage {
        let tempScale: CGFloat = scale < 0 ? 0 : scale
        let size = self.bounds.size
        UIGraphicsBeginImageContextWithOptions(size, false, tempScale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        var img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        img = UIImage.init(cgImage: img.cgImage!, scale: UIScreen.main.scale, orientation: .up)
        UIGraphicsEndImageContext()
        return img
    }
    
    func imageFromViewInRect(rect: CGRect) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        UIGraphicsGetCurrentContext()!.translateBy(x: -rect.origin.x, y: -rect.origin.y);
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        var img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        img = UIImage.init(cgImage: img.cgImage!, scale: UIScreen.main.scale, orientation: .up)
        UIGraphicsEndImageContext()
        return img
    }
}
