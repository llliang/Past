//
//  PHttpManager.swift
//  Past
//
//  Created by jiangliang on 2018/3/25.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import Foundation
import Alamofire

let HostName = "http://localhost:3000"

class PHttpManager {
    
    class func requestAsynchronous(url: String, method: HTTPMethod, parameters: Dictionary<String, String>?,completion: @escaping (_ data: Dictionary<String, AnyObject>, _ error: NSError?) -> ()) {
      
        var params = parameters
        if params == nil {
            params = Dictionary<String, String>()
        }
        
        let token = PUserSession.instance.session?.token
        if let _ = token {
            params!["token"] = token
        }
        
        #if DEBUG
            var string = "?softversion=\(Util.appVersion())&systype=ios&sysversion=\(Util.systemVersion())"
            if let ps = params {
                for key in ps.keys {
                    string = string + "&" + key + "=" + ps[key]!
                }
            }
            print(HostName + url + string)
        #endif
        
        Alamofire.request((HostName + url), method:method, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                let result = response.result.value as! Dictionary<String, AnyObject>
                completion(result, nil)
            } else {
                print(response.result.error.debugDescription)
            }
        }
    }
}
