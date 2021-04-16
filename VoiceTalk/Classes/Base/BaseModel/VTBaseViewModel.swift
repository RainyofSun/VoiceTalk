//
//  VTBaseViewModel.swift
//  VoiceTalk
//
//  Created by macos on 2021/4/16.
//  Copyright © 2021 macos. All rights reserved.
//

import UIKit

class VTBaseViewModel: NSObject {
    deinit {
        printLog(String(format: "DELLOC %@", self));
    }
}
