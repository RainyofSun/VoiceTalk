//
//  VTRedPointLabel.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/23.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTRedPointLabel: UIView {

    open var text: String? {
        didSet {
            vt_dispatch_main_block { [weak self] in
                if self!.text != nil {
                    if self!.text == "0" {
                        self!.isHidden = true
                        self!.textLab.text = ""
                    } else {
                        self?.isHidden = false
                    }
                    self!.reloadBadgeValue()
                } else {
                    self!.removeTagValue()
                }
            }
        }
    } // default is nil
    open var font: UIFont? = VTMediumFont10 // default is 13
    open var textColor: UIColor? = VTWhiteColor // default is VTMainColor
    open var pointBackgroundColor: UIColor? = VTRedColor // default is VTRedColor
    open var textEdgeInset: UIEdgeInsets? = UIEdgeInsets.zero
    open var hidesWhenZero: Bool? = true
    
    private lazy var textLab: UILabel = {
        let label = UILabel.init()
        label.autoresizingMask = [.flexibleTopMargin,.flexibleBottomMargin]
        label.textColor = self.textColor
        label.font = self.font
        label.textAlignment = .center
        return label
    }()
    
    private let pointWidth: CGFloat = 15.0
    private let pointHeight: CGFloat = 15.0
    
    init(position: CGPoint) {
        super.init(frame: CGRect.init(x: position.x, y: position.y, width: pointWidth, height: pointHeight))
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        printLog("DELLOC " + self.description)
    }
}

extension VTRedPointLabel {
    func setupUI() {
        self.backgroundColor = self.pointBackgroundColor
        self.layer.cornerRadius = self.vt_height * 0.5
        self.clipsToBounds = true
    }
    
    func reloadBadgeValue() {
        self.textLab.text = self.text
        let textW = self.text!.textWidth(font: self.font!, constraintHeight: (self.pointHeight + self.textEdgeInset!.top + self.textEdgeInset!.bottom))
        self.vt_width = max(textW, pointWidth) + self.textEdgeInset!.left + self.textEdgeInset!.right
        self.textLab.frame = CGRect.init(x: self.textEdgeInset!.left, y: self.textEdgeInset!.top, width: (self.vt_width - self.textEdgeInset!.left - self.textEdgeInset!.right), height: (self.vt_height - self.textEdgeInset!.top - self.textEdgeInset!.bottom))
        self.addSubview(self.textLab)
    }
    
    func removeTagValue() {
        if self.textLab.superview != nil {
            self.textLab.removeFromSuperview()
        }
    }
}
