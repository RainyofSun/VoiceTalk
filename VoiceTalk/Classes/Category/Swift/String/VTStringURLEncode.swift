//
//  VTStringURLEncode.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/14.
//  Copyright © 2021 macos. All rights reserved.
//

import Foundation

extension String {
    func urlEncode() -> String {
        var allowedQueryParamAndKey = NSCharacterSet.urlQueryAllowed
            allowedQueryParamAndKey.remove(charactersIn: ":/?#[]@!$&’()*+,;=")
        let encodeStr = addingPercentEncoding(withAllowedCharacters: allowedQueryParamAndKey) ?? self
        return encodeStr
    }
    
    func urlDecode() -> String {
        return self.removingPercentEncoding ?? ""
    }
}
