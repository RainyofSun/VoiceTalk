//
//  VTAssociateProperty.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/29.
//  Copyright © 2021 macos. All rights reserved.
//

/*
 swift 属性关联
 https://www.jianshu.com/p/75de1a6e28f2
 */
import Foundation

extension NSObject {
    func setAssociated<T>(value: T, associatedKey: UnsafeRawPointer, policy: objc_AssociationPolicy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        objc_setAssociatedObject(self, associatedKey, value, policy)
    }
    
    func getAssociated(associatedKey: UnsafeRawPointer) -> Any? {
        let value = objc_getAssociatedObject(self, associatedKey)
        return value
    }
}
