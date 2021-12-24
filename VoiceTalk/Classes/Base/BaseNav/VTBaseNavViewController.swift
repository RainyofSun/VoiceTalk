//
//  VTBaseNavViewController.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/23.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTBaseNavViewController: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        if above_ios_13 {
            self.modalPresentationStyle = .fullScreen
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        if above_ios_13 {
            self.modalPresentationStyle = .fullScreen
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if above_ios_13 {
            self.modalPresentationStyle = .fullScreen
        }
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
