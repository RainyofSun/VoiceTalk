//
//  VTTopViewController.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/5.
//  Copyright © 2022 macos. All rights reserved.
//

import UIKit

extension UIView{

    func getFirstViewController()->UIViewController?{
        for view in sequence(first: self.superview, next: {$0?.superview}){
            if let responder = view?.next{
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
}
