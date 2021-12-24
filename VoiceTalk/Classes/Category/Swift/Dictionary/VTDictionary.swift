//
//  VTDictionary.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/16.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

extension Dictionary {
    static func dictionaryWithDictionary(otherDict:Dictionary<String,Any>) -> Dictionary<String,Any> {
        var tempDict = Dictionary<String,Any>.init()
        tempDict.merge(otherDict) {(current,_) -> Any in current}
        return tempDict
    }
}
