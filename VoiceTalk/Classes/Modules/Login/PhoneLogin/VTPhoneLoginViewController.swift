//
//  VTPhoneLoginViewController.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/22.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTPhoneLoginViewController: VTBaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellow
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.popViewController(animated: true)
    }
    
    deinit {
        printLog("DELLOC : %@",self.description)
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
