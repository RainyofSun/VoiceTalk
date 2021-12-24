//
//  ColorFile.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/23.
//  Copyright © 2021 macos. All rights reserved.
//

import Foundation
import UIKit

// 纯色
let VTWhiteColor = UIColor.white
let VTBlackColor = UIColor.black
let VTYellowColor = UIColor.yellow
let VTBlueColor  = UIColor.blue
let VTRedColor   = UIColor.red
let VTGrayColor  = UIColor.gray
let VTGreenColor = UIColor.green
let VTClearColor = UIColor.clear

// 自定义颜色
let VT3b3b3bColor = UIColor.init(hexString: "3b3b3b")
let VT999999Color = UIColor.init(hexString: "999999")
let VTEdededColor = UIColor.init(hexString: "ededed")
let VT000000Color = VTBlackColor
let VTFFFFFFColor = VTWhiteColor
let VTFae100Color = UIColor.init(hexString: "fae100")
let VTEeeeeeColor = UIColor.init(hexString: "eeeeee")
let VTC5c5c5Color = UIColor.init(hexString: "c5c5c5")
let VTF2f2f2Color = UIColor.init(hexString: "f2f2f2")
let VTMainColor   = UIColor.init(hexString: "333333") // 黑色主色调

let tabbarSelectedColor = RGBCOLOR(r: 27.0, 64.0, 30.0, 1.0)
let tabbarNormalColor = RGBCOLOR(r: 179.0, 179.0, 179.0, 0.3)

// 颜色
func RGBCOLOR(r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat) -> UIColor {
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: a)
}

func VTColor(hexString: String, alpha: CGFloat) -> UIColor {
    return UIColor.init(hexString: hexString, alpha: alpha)
}

extension UIColor {
    // Hex String -> UIColor
    convenience init(hexString: String, alpha: CGFloat) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
         
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
         
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
         
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
         
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
         
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // Hex String -> UIColor
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
         
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
         
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
         
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
         
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
         
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
     
    // UIColor -> Hex String
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
         
        let multiplier = CGFloat(255.999999)
         
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
         
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        } else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}
