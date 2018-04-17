//
//  PHttpManager.swift
//  Past
//
//  Created by jiangliang on 2018/3/25.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import Foundation
import Alamofire

//let HostName = "http://localhost:3000"

//let HostName = "http://192.168.3.64:3000" // 公司
//let HostName = "http://192.168.0.100:3000" // 家


class PHttpManager {
    
    struct Result {
        var code: Int
        var data: Any?
        var message: String
        var error: NSError?
    }
    
    class func requestAsynchronous(url: String, method: HTTPMethod, parameters: Dictionary<String, Any>?,completion: @escaping (_ data: Result) -> ()) {
      
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
                    var value: String
                    let val = ps[key]
                    if val is NSNumber {
                        value = NSString(format: "%@", val as! NSNumber) as String
                    } else {
                        value = val as! String
                    }
                    string = string + "&" + key + "=" + value
                }
            }
            print(HostName + url + string)
        #endif

        Alamofire.request((HostName + url), method:method, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                let result = response.result.value as! Dictionary<String, AnyObject>
                if let status = result["status"] {
//                    completion(nil, NSError(domain: result["exception"] as! String, code: status as! Int, userInfo: nil));
                    completion(Result(code: status as! Int, data: nil, message: result["exception"] as! String, error: NSError(domain: result["exception"] as! String, code: status as! Int, userInfo: nil)))
                    Hud.show(content: result["exception"] as! String)
                } else {
//                   completion(result, nil)
                    completion(Result(code:Int(truncating: result["code"] as! NSNumber), data: result["data"], message: result["message"] as! String, error: nil))
                    if result["code"]?.int64Value == -10001 {
                        PUserSession.instance.exitSession()
                    }
                }
            } else {
                print(response.result.error.debugDescription) //
//                completion(nil, NSError(domain: response.result.error.debugDescription, code: -100001, userInfo: nil))
                completion(Result(code: -100001, data: nil, message: "", error: NSError(domain: response.result.error.debugDescription, code: -100001, userInfo: nil)))
            }
        }
    }
}
