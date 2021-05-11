//
//  VTBaseModel.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/15.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTBaseModel: HandyJSON {
    required init(){
        
    };
    
    /**
     *  Json转对象
     */
    open class func jsonToModel(_ jsonStr:String,_ modelType:HandyJSON.Type) ->VTBaseModel {
        if jsonStr == "" || jsonStr.count == 0 {
            #if DEBUG
            print("jsonoModel:字符串为空")
            #endif
            return VTBaseModel()
        }
        return modelType.deserialize(from: jsonStr)  as! VTBaseModel
        
    }
    
    /**
     *  Json转数组对象
     */
    open class func jsonArrayToModel(_ jsonArrayStr:String, _ modelType:HandyJSON.Type) ->[VTBaseModel] {
        if jsonArrayStr == "" || jsonArrayStr.count == 0 {
            #if DEBUG
            print("jsonToModelArray:字符串为空")
            #endif
            return []
        }
        var modelArray:[VTBaseModel] = []
        let data = jsonArrayStr.data(using: String.Encoding.utf8)
        let peoplesArray = try! JSONSerialization.jsonObject(with:data!, options: JSONSerialization.ReadingOptions()) as? [AnyObject]
        for people in peoplesArray! {
            modelArray.append(dictionaryToModel(people as! [String : Any], modelType))
        }
        return modelArray
        
    }
    
    /**
     *  字典转对象
     */
    open class func dictionaryToModel(_ dictionStr:[String:Any],_ modelType:HandyJSON.Type) -> VTBaseModel {
        if dictionStr.count == 0 {
            #if DEBUG
            print("dictionaryToModel:字符串为空")
            #endif
            return VTBaseModel()
        }
        return modelType.deserialize(from: dictionStr) as! VTBaseModel
    }
    
    /**
     *  对象转JSON
     */
    open class func modelToJson(_ model:VTBaseModel?) -> String {
        if model == nil {
            #if DEBUG
            print("modelToJson:model为空")
            #endif
            return ""
        }
        return (model?.toJSONString())!
    }
    
    /**
     *  对象转字典
     */
    open class func modelToDictionary(_ model:VTBaseModel?) -> [String:Any] {
        if model == nil {
            #if DEBUG
            print("modelToJson:model为空")
            #endif
            return [:]
        }
        return (model?.toJSON())!
    }
    
    
    //数组转json
    open class func arrayToJson(_ array:NSArray) -> String {
        if (!JSONSerialization.isValidJSONObject(array)) {
            print("无法解析出JSONString")
            return ""
        }
        
        let data : NSData! = try? JSONSerialization.data(withJSONObject: array, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }
    
    /**
     * 字典转JSON
     */
    open class func dictionaryToJson(_ dictionary:NSDictionary) -> String {
        if (!JSONSerialization.isValidJSONObject(dictionary)) {
            print("无法解析出JSONString")
            return ""
        }
        let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
        
    }
}
