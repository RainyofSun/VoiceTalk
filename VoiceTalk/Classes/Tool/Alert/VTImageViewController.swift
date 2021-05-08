//
//  VTImageViewController.swift
//  VoiceTalk
//
//  Created by macos on 2021/5/7.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTImageViewController: VTBaseAlertViewController {

    var maskView = UIView.init();
    var bgView = UIView.init();
    var alertImgView = UIImageView.init();
    var contentLab = UILabel.init();
    var sureBtn = UIButton.init(type: UIButton.ButtonType.custom);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        weak var weakSelf = self;
        self.dismissViewController {
            if weakSelf?.completeBlock != nil {
                weakSelf?.completeBlock!(1);
            }
        };
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor.clear;
        // 背景色
        self.maskView.backgroundColor = UIColor.black.withAlphaComponent(0.3);
        
        self.bgView.backgroundColor = UIColor.white;
        self.bgView.layer.cornerRadius = 8;
        self.bgView.clipsToBounds = true;
        
        self.alertImgView.image = UIImage.init(named: self.imgName != nil ? self.imgName! : "register_icon_prompt");
        
        self.contentLab.text = self.message;
        self.contentLab.textColor = appSubTextColor;
        self.contentLab.font = appFont(fontSize: 15);
        
//        self.sureBtn.setTitle('', for: <#T##UIControl.State#>)
        
        self.view.addSubview(self.maskView);
        self.maskView.addSubview(self.bgView);
        self.bgView.addSubview(self.alertImgView);
        self.bgView.addSubview(self.contentLab);
        
        self.maskView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview();
        };
        self.maskView.snp.makeConstraints { (make) in
            make.center.equalToSuperview();
            make.width.equalTo(screen_width * 0.64);
            make.height.equalTo(screen_height * 0.4);
        }
        self.alertImgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(space(times: 2));
        }
        self.contentLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview();
            make.top.equalTo(self.alertImgView.snp.bottom).offset(space(times: 2));
            
        }
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
