//
//  ServiceInterviceFile.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/16.
//  Copyright © 2021 macos. All rights reserved.
//

import Foundation

// 接口

/// - 登陆
// 检测用户是否已注册
let check_tel_exist         = "/appUser/checkTelExist/";
// 获取验证码
let get_verification_code   = "/appUser/getVerificationCode/"
// 登陆
let user_login              = "/appUser/login"
// 临时用户
let casual_user             = "/casualUser/createCasualUser"
// 校验验证码
let check_vertification_code = "/appUser/checkVerificationCode"
// 设置密码
let setting_password        = "/appUser/setPassword"
// 忘记密码
let forget_password         = "/appUser/forgetPassword"
// 上传头像
let upload_user_portrait    = "/appUser/uploadUserPicture"
// 获取用户信息
let find_user_info          = "/appUser/findUserInfo/"
// 重置用户密码
let reset_user_password     = "/appUser/resetPassword"
