//
//  VTObjectThread.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/24.
//  Copyright © 2021 macos. All rights reserved.
//

import Foundation

public func vt_dispatch_main_block(work: @escaping @convention(block) () -> Void) {
    if Thread.current.isMainThread {
        work()
    } else {
        DispatchQueue.main.async {
            work()
        }
    }
}

public func vt_dispatch_after_block(time: DispatchTime, work: @escaping @convention(block) () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: time) {
        work()
    }
}


