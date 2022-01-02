//
//  VTBaseViewController.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/12.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTBaseViewController: UIViewController {

    public weak var openURLContext: VTOpenURLContext?
    public var addBackGesture: Bool? = false
    
    fileprivate(set) var openURLParameters: Dictionary<String,Any>?
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.vt_height = self.view.vt_height + 15
    }
    
    deinit {
        printLog("DELLOC : ",self.description)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
