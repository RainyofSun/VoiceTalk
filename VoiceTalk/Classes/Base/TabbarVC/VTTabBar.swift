//
//  VTTabBar.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/23.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

protocol VTTabBarDelegate: NSObjectProtocol {
    // 将要选中TabBarItem
    func tabbarWillSelectedItem(tabbar: VTTabBar,selectedIndex: Int) -> Bool
    // 已经选中TabBarItem
    func tabbarDidSelectedItem(tabbar: VTTabBar,selectedIndex: Int)
    // 长按拍摄按钮 --> 可选
    func tabbarLongPressedComposeItem(tabbar: VTTabBar,selectedIndex: Int)
}

extension VTTabBarDelegate {
    func tabbarLongPressedComposeItem(tabbar: VTTabBar,selectedIndex: Int) {
        
    }
}

class VTTabBar: UIView {

    open weak var tabbarDelegate: VTTabBarDelegate?
    fileprivate(set) var selectIndex: Int? = 0  // 下标选中,默认为0
    fileprivate(set) var selectedItem: VTTabBarItem! // 当前选中的Item
    fileprivate(set) var composeTop: CGFloat = 15.0
    
    private var items: Array<VTTabBarItem> = []
    private var composeButton: VTTabBarItem!
    private var normalBgView: UIView = UIView.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.normalBgView.frame = CGRect.init(x: 0, y: composeTop, width: self.vt_width, height: self.vt_height - composeTop)
        guard self.items.isEmpty == false else {
            return
        }
        let count = self.items.count
        let itemWidth: CGFloat = self.vt_width * 0.2
        let marginX: CGFloat = 0
        let composeIndex = count/2
        for itemIndex in 0..<count {
            let tempItem = self.items[itemIndex]
            if itemIndex < composeIndex {
                tempItem.frame = CGRect.init(x: itemWidth * CGFloat(itemIndex) + marginX, y: 0, width: itemWidth, height: 49)
            }
            if itemIndex > composeIndex {
                let itemX = self.vt_width - (itemWidth * CGFloat((count - itemIndex)) + marginX)
                tempItem.frame = CGRect.init(x: itemX, y: 0, width: itemWidth, height: 49)
            }
        }
        self.composeButton.frame = CGRect.init(x: self.vt_width * 0.5 - itemWidth * 0.5, y: self.normalBgView.vt_top - 8, width: itemWidth, height: 57)
        self.bringSubviewToFront(self.composeButton)
    }
    
    deinit {
        self.deallocTabBarItems()
        printLog("DELLOC " + self.description)
    }
    
    public func buildTabBarItems(titles: Array<String>, normalImgs: Array<String>, selectedImgs: Array<String>) {
        guard normalImgs.isEmpty == false && titles.isEmpty == false && selectedImgs.isEmpty == false else {
            printLog("TabBar Items Source Empty")
            return
        }
        guard (normalImgs.count == titles.count) && (normalImgs.count == selectedImgs.count) else {
            printLog("TabBar Items Source Error")
            return
        }
        
        for index in 0..<normalImgs.count {
            let normalImg = UIImage.init(named: normalImgs[index])!
            let selectedImg = UIImage.init(named: selectedImgs[index])!
            let tabbarItem = VTTabBarItem.init(title: titles[index], image: normalImg, selectedImage: selectedImg)
            tabbarItem.addTarget(self, action: #selector(selectedTabBarItem(sender:)), for: .touchUpInside)
            self.items.append(tabbarItem)
            self.normalBgView.addSubview(tabbarItem)
        }
        self.composeButton = buildComposeButton()
        self.addSubview(self.composeButton)
        self.items.insert(self.composeButton, at: 2)
    }
    
    public func selectedTabBarItem(selectedIndex: Int) {
        self.selectedItem = self.items[selectedIndex]
        if self.selectedItem.isSelected {
            return
        }
        self.reloadTabBarItemsStatus()
        self.selectIndex = selectedIndex
        self.selectedItem.isSelected = true
    }
}

extension VTTabBar {
    func setupUI() {
        self.backgroundColor = VTClearColor
        self.clipsToBounds = false
        
        self.normalBgView.backgroundColor = VTWhiteColor
        self.normalBgView.autoresizingMask = .flexibleBottomMargin
        self.addSubview(self.normalBgView)
    }
    
    func buildComposeButton() -> VTTabBarItem {
        let img: UIImage = UIImage.init(named: "navigation_tab_camera_selected_icon-1")!
        let tempItem = VTTabBarItem.init(title: nil, image: img, selectedImage: img)
        tempItem.frame = CGRect.init(x: 0, y: 0, width: screen_width * 0.2, height: 49 + composeTop)
        tempItem.addTarget(self, action: #selector(selectedTabBarItem(sender:)), for: .touchUpInside)
        tempItem.contentHorizontalAlignment = .center
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressed(sender:)))
        longPressGesture.minimumPressDuration = 0.3
        tempItem.addGestureRecognizer(longPressGesture)
        return tempItem
    }
    
    func reloadTabBarItemsStatus() {
        for item in self.items {
            if item.isSelected {
                item.isSelected = false
                break
            }
        }
    }
    
    func deallocTabBarItems() {
        self.items.forEach({ tempItem in
            tempItem.removeFromSuperview()
        })
        self.items.removeAll()
    }
    
    // Target
    @objc func longPressed(sender:UIGestureRecognizer) {
        self.tabbarDelegate?.tabbarLongPressedComposeItem(tabbar: self, selectedIndex: 2)
    }
    
    @objc func selectedTabBarItem(sender: VTTabBarItem) {
        let canSelected: Bool = self.tabbarDelegate?.tabbarWillSelectedItem(tabbar: self, selectedIndex: self.selectIndex!) ?? true
        if canSelected {
            let index: Int = (self.items.firstIndex(where: {$0 == sender}))!
            self.tabbarDelegate?.tabbarDidSelectedItem(tabbar: self, selectedIndex: index)
        }
    }
}
