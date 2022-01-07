//
//  VTBaseViewController.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/12.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTBaseViewController: UIViewController {

    open weak var openURLContext: VTOpenURLContext?
    open var addBackGesture: Bool? = true
    open var showBackButton: Bool? = true {
        didSet {
            if !self.showBackButton! {
                // 删除系统的返回按钮
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: UIView.init())
            }
        }
    }
    open var shouldBaseControllNavBar: Bool? = true
    open var UUIDStr: String?
    open var TDPageID: String?
    // default：YES 在iOS 9上setNavigationBarHidden：YES时会导致scrollView调didScrolled
    open var needHideNavBarWhenViewWillDisappear: Bool? = true
    fileprivate(set) var openURLParameters: Dictionary<String,Any>?
    
    override var title: String? {
        didSet {
            if self.title == nil || self.title!.count == 0 {
                return
            }
            if self.navigationItem.titleView == nil {
                let customTitle: VTNavigationTitleView = VTNavigationTitleView.init()
                customTitle.refreshTitle(title: self.title!)
                self.navigationItem.titleView = customTitle
            } else if self.navigationItem.titleView!.isKind(of: VTNavigationTitleView.self) {
                let tempTitleView: VTNavigationTitleView = self.navigationItem.titleView as! VTNavigationTitleView
                tempTitleView.refreshTitle(title: self.title!)
            }
        }
    }
    
    private lazy var noDataView: VTNODataLabel = {
        let tempLab:VTNODataLabel = VTNODataLabel.init(text: LanguageTool.language(key: "请求失败，请检查网络并重试"))
        return tempLab
    }()
    
    @objc public func onLanguageChange(notification: Notification) {
        
    }
    
    // Mark pop 时机
    public func willPopOut() {
        
    }
    
    public func popOut() {
        self.view.endEditing(true)
        guard self.navigationController != nil else {
            if let navController: UINavigationController = self.view.getFirstViewController()?.navigationController {
                if navController.viewControllers.first == self || navController.viewControllers.count == 1 {
                    self.view.getFirstViewController()?.dismiss(animated: true, completion: nil)
                } else {
                    navController.popViewController(animated: true)
                }
            }
            return
        }
        if self.navigationController!.viewControllers.first == self || self.navigationController!.viewControllers.count == 1 {
            self.dismiss(animated: true, completion: nil)
            return
        }
        self.navigationController!.popViewController(animated: true)
    }
    
    public func didPopOut() {
        
    }
    
    // 释放时清理工作
    public func dojobWhenDealloc() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK 网络请求失败提示
    public func showNoDataView() {
        self.showNoDataViewInView(superView: self.view,topMarin: 120)
    }
    
    public func showNoDataViewInView(superView: UIView,topMarin: CGFloat = 0) {
        self.noDataView.vt_top = topMarin
        self.noDataView.isHidden = false
    }
    
    public func hiddenNoDataView() {
        self.noDataView.isHidden = true
    }
    
    // MARK 风火轮
    public func showLoadingIndicator() {
        VTHudTool.hudShow()
    }
    
    public func hideLoadingIndicator() {
        VTHudTool.hidHud()
    }
    
    // MARK 显示顶部提示条
    public func showTopTip(text: String) {
        let topWarning: VTTopWarningControl = VTTopWarningControl.init(title:text)
        topWarning.backgroundColor = VTColor(hexString: "ffd600", alpha: 0.7)
        if self.navigationController!.isNavigationBarHidden {
            self.navigationController!.view.insertSubview(topWarning, belowSubview: self.navigationController!.navigationBar)
        } else {
            self.navigationController!.navigationBar.subviews.first?.insertSubview(topWarning, at: 0)
        }
        topWarning.show()
    }
    
    // MARK - Public methods
    required init(context:VTOpenURLContext) {
        super.init(nibName: nil, bundle: nil)
        self.openURLContext = context
        self.openURLParameters = context.parameters
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        if above_ios_13 {
            self.modalPresentationStyle = .fullScreen
        }
        addNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = VTWhiteColor
        var isRoot: Bool = self.navigationController?.viewControllers.first == self
        if isRoot {
            isRoot = self.presentedViewController == nil
        }
        if self.showBackButton! && !isRoot {
            weak var weakSelf = self
            self.navigationItem.leftBarButtonItem = VTBarButtonItem.backButtomItem(clicked: { sender in
                if let strongSelf = weakSelf {
                    strongSelf.popOut()
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.navigationController?.presentedViewController == nil && self.shouldBaseControllNavBar! {
            if above_ios_11 {
                self.navigationController?.setNavigationBarHidden(self.navigationItem.hideNavigationBar ?? true, animated: false)
            } else {
                self.navigationController?.setNavigationBarHidden(self.navigationItem.hideNavigationBar ?? true, animated: animated)
            }
        }
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.navigationController?.presentedViewController == nil && self.shouldBaseControllNavBar! && self.needHideNavBarWhenViewWillDisappear! {
            if self.navigationController?.isNavigationBarHidden == false {
                self.navigationController?.setNavigationBarHidden(true, animated: false)
            }
        }
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.vt_height = self.view.vt_height + 15
    }
    
    deinit {
        dojobWhenDealloc()
        printLog("DELLOC : ",self.description)
    }
}

extension VTBaseViewController {
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(onLanguageChange(notification:)), name: NSNotification.Name.init(rawValue: SwitchLanguageNotification), object: nil)
    }
}
