//
//  VTZoneDynamicPageViewController.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/19.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTZoneDynamicPageViewController: VTBaseViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.navigationItem.hideNavigationBar = true
    }
    
    required init(context: VTOpenURLContext) {
        fatalError("init(context:) has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // kksksk
        // Do any additional setup after loading the view.
        self.view.backgroundColor = VTGrayColor
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
