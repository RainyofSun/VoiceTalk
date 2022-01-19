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
class VTBaseUserInfoModel: VTBaseModel,NSCoding {
    var userId : String?
    var nickname : String?
    var accountNo : String?
    var token : String?
    var loginTime : String?
    
    var userStories : String?
    var country : String?
    var birthday : String?

    func mapping(mapper: HelpingMapper) {
        // 重新指定 id 字段
        mapper.specify(property: &userId, name: "id")
    }
    
    // 在对象归档的时候调用（哪些属性需要归档，怎么归档）
     func encode(with aCoder: NSCoder) {
        aCoder.encode(userId, forKey: "userId");
        aCoder.encode(nickname, forKey: "nickname");
        aCoder.encode(accountNo,forKey: "accountNo");
        aCoder.encode(token,forKey: "token");
        aCoder.encode(userStories,forKey: "userStories");
        aCoder.encode(country,forKey: "country");
        aCoder.encode(birthday, forKey: "birthday");
        aCoder.encode(loginTime,forKey: "loginTime");
     }
    
     // 解析NIB/XIB的时候会调用
    required init?(coder aDecoder: NSCoder) {
        super.init()
        userId = aDecoder.decodeObject(forKey: "userId") as? String
        nickname = aDecoder.decodeObject(forKey: "nickname") as? String
        accountNo = aDecoder.decodeObject(forKey: "accountNo") as? String
        token = aDecoder.decodeObject(forKey: "token") as? String
        userStories = aDecoder.decodeObject(forKey: "userStories") as? String
        birthday = aDecoder.decodeObject(forKey: "birthday") as? String
        country = aDecoder.decodeObject(forKey: "country") as? String
        loginTime = aDecoder.decodeObject(forKey: "loginTime") as? String
     }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
