//
//  BundlePathFile.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/23.
//  Copyright © 2021 macos. All rights reserved.
//

import Foundation

// SVG资源路径
func SVGResourcePath(fileName:String?, imgName:String) -> String {
    let bundlePath = Bundle.main.path(forResource: "SVGResBundle", ofType: "bundle");
    let localBundle = Bundle.init(path: bundlePath!);
    var filePathName = imgName;
    if fileName != nil {
        filePathName = String(format: "/%@/%@", fileName!,imgName);
    }
    return (localBundle?.path(forResource: filePathName, ofType: "svg")) ?? "没有地址";
}

