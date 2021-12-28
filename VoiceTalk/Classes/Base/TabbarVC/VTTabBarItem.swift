//
//  VTTabBarItem.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/23.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTTabBarItem: UIButton {
    
    open var showNewTipBadge: Bool? = false // 是否显示小红点 默认不显示
    open var selectedImage: UIImage?
    open var badgeValue: String? // default is nil
    @NSCopying open var badgeColor: UIColor?
    
    private lazy var redPointLab: VTRedPointLabel = {
        let tempLab = VTRedPointLabel.init(position: CGPoint.init(x: 0, y: 0))
        tempLab.text = self.badgeValue
        tempLab.snp.makeConstraints { make in
            make.right.top.equalTo(self)
        }
        return tempLab
    }()
    
    public convenience init(title: String?, image: UIImage?, tag: Int) {
        self.init(frame: CGRect.zero)
        self.setImage(image, for: .normal)
        self.setImage(selectedImage, for: .selected)
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .selected)
    }

    public convenience init(title: String?, image: UIImage?, selectedImage: UIImage?) {
        self.init(frame: CGRect.zero)
        self.selectedImage = selectedImage
        self.setImage(image, for: .normal)
        self.setImage(selectedImage, for: .selected)
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .selected)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.currentImage != nil {
            let x = self.vt_half_width - self.currentImage!.size.width * 0.5
            self.imageView?.frame = CGRect.init(x: x, y: 0, width: self.currentImage!.size.width, height: self.currentImage!.size.height)
        }
        self.titleLabel?.frame = CGRect.init(x: 0, y: self.imageView!.vt_bottom + 3, width: self.vt_width, height: 10)
    }
    
    deinit {
        printLog("DELLOC" + self.description)
    }
}

extension VTTabBarItem {
    func setupUI() {
        self.adjustsImageWhenHighlighted = false
        self.setTitleColor(VT999999Color, for: .normal)
        self.setTitleColor(VT3b3b3bColor, for: .selected)
        self.titleLabel?.font = VTNormalFont10
        self.titleLabel?.textAlignment = .center
    }
}
