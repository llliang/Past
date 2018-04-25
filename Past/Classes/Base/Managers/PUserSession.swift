//
//  PUserSession.swift
//  Past
//
//  Created by jiangliang on 2018/3/22.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

let PUserSessionChanged: NSNotification.Name = NSNotification.Name(rawValue: "past.userSession.changed")
let PUserSessionCacheKey = "past.userSession.CacheKey"

class PUserSession: NSObject {
    
    var session: PSession?
    
    override init() {
        session = PCacheManager.instance.cache(forKey: PUserSessionCacheKey)
    }
    
    static let instance = PUserSession()
    
    func validSession() -> Bool {
        if let _ = session {
            return !(session?.token?.isEmpty)!
        }
        return false
    }
    
    func updateSession(dic: Dictionary<String, Any>) {
        session = PSession.toEntity(data: dic)
        self.cacheSession(session: session!)
    }
    
    func cacheSession(session: PSession) {
        self.session = session
        _ = PCacheManager.instance.setCache(cache: session, forKey: PUserSessionCacheKey)
    }
    
    func exitSession() {
        session = nil
        PCacheManager.instance.removeCache(forKey: PUserSessionCacheKey)
        NotificationCenter.default.post(name: PUserSessionChanged, object: nil)
    }
    
}
