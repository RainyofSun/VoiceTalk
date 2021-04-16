//
//  VTBaseUserInfoModel.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/15.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

/**
 * 用户属性Model
 */
class VTBaseUserInfoModel: VTBaseModel {
    var userId : String?
    var nickname : String?
    var accountNo : String?
    var token : String?
    var rcToken : String?
    
    var userStories : String?
    var country : String?
    var birthday : String?
    var userType : int_fast64_t?

    func mapping(mapper: HelpingMapper) {
        // 重新指定 id 字段
        mapper.specify(property: &userId, name: "id")
    }
}
