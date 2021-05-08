//
//  ColorFile.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/23.
//  Copyright © 2021 macos. All rights reserved.
//

import Foundation

// 主色调
let mainColor = RGBCOLOR(r: 80.0, 191.0, 90.0,0.5)

let tabbarSelectedColor = RGBCOLOR(r: 27.0, 64.0, 30.0, 1.0)
let tabbarNormalColor = RGBCOLOR(r: 179.0, 179.0, 179.0, 0.3)

// 黑色
let systemBlack = RGBCOLOR(r: 0, 0, 0, 0.85)
// 次级标题字体色
let appSubTextColor = RGBCOLOR(r:44, 54, 45, 0.8)

// 颜色
func RGBCOLOR(r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat) -> UIColor {
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: a)
}
