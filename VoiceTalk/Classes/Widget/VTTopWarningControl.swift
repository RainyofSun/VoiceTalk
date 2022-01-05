//
//  VTTopWarningControl.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2022/1/5.
//  Copyright © 2022 macos. All rights reserved.
//

import UIKit

class VTTopWarningControl: UIButton {

    private var hideTop: CGFloat = 0
    private var animationDiration: CGFloat = 5
    private var arrowImgView: UIImageView? = nil
    
    public func refreshTitle(title: String) {
        self.setTitle(title, for: .normal)
        if self.arrowImgView != nil {
            let textW: CGFloat = title.textWidth(font: self.titleLabel!.font)
            self.arrowImgView!.vt_left = (screen_width - textW) * 0.5 + textW + 8
        }
    }
    
    public func show() {
        guard self.superview != nil else {
            return
        }
        
        guard let topViewController: UIViewController = self.getFirstViewController() else {
            return
        }
        var navController: UINavigationController? = nil
        if topViewController.isKind(of: UINavigationController.self) {
            navController = topViewController as? UINavigationController
        } else {
            navController = topViewController.navigationController
        }
        
        guard navController != nil else {
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            if self.superview == navController!.view {
                self.vt_top = navController!.navigationBar.vt_bottom
            } else {
                self.vt_top = self.superview!.vt_height
            }
        } completion: { [self] finished in
            self.perform(#selector(hide(callnack:)), with: nil, afterDelay: self.animationDiration)
        }
    }
    
    public func showWithTop(top: CGFloat = 0) {
        guard self.superview != nil else {
            return
        }
        UIView.animate(withDuration: 0.3) {
            self.vt_top = top
        } completion: { [self] finished in
            self.perform(#selector(hide(callnack:)), with: nil, afterDelay: self.animationDiration)
        }
    }
    
    @objc public func hide(callnack:@escaping ()->()) {
        UIView.animate(withDuration: 0.3) {
            self.vt_top = -1 * self.vt_height
        } completion: { finished in
            callnack()
            self.removeFromSuperview()
        }
    }
    
    init(title: String = "", showArrow:Bool = false, duration: CGFloat = 5) {
        super.init(frame: CGRect.init(x: 0, y: -25, width: screen_width, height: 25))
        self.backgroundColor = VTColor(hexString: "ff3737", alpha: 0.7)
        self.setTitle(title, for: .normal)
        self.setTitleColor(VTBlackColor, for: .normal)
        self.titleLabel?.font = VTNormalFont12
        self.animationDiration = duration
        if showArrow {
            let textW: CGFloat = title.textWidth(font: VTNormalFont12)
            self.arrowImgView = UIImageView.init(image: UIImage.init(named: ""))
            self.arrowImgView!.vt_left = (screen_width - textW) * 0.5 + textW + 8
            self.arrowImgView!.vt_center_y = self.vt_half_height
            self.addSubview(self.arrowImgView!)
        }
        self.hideTop = -9999;
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        printLog("DELLOC ",self.description)
    }

}
