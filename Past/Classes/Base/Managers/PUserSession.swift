//
//  PUserSession.swift
//  Past
//
//  Created by jiangliang on 2018/3/22.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PUserSession: NSObject {
   class func shareInstance() -> PUserSession {
        let session = PUserSession()
        return session
    }
    
    func validSession() -> Bool {
        return false
    }
}
