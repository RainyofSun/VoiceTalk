//
//  VTVersionViewController.swift
//  VoiceTalk
//
//  Created by macos on 2021/5/11.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTVersionViewController: VTBaseAlertViewController {

    var maskView : UIView?
    var bgView : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI();
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor.clear;
        self.maskView = UIView.init();
        self.maskView?.backgroundColor = UIColor.clear;
        
        self.bgView = UIView.init();
        self.bgView?.backgroundColor = UIColor.white;
        self.bgView?.layer.cornerRadius = 10;
        self.bgView?.clipsToBounds = true;
        
        self.view.addSubview(self.maskView!);
        self.maskView?.addSubview(self.bgView!);
        
        self.maskView?.snp.makeConstraints({ (make) in
            make.center.size.equalTo(self.view);
        });
        self.bgView?.snp.makeConstraints({ (make) in
            make.center.equalToSuperview();
            make.width.equalTo(self.view.snp.width).multipliedBy(0.62);
        })
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
