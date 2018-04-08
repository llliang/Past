//
//  PDataModel.swift
//  Past
//
//  Created by jiangliang on 2018/4/2.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit
import Alamofire

class PDataModel<Element: Entity, Type>: NSObject {
    var code: NSInteger?
    var message: String?
    var data: Type?
    var cacheKey: String?
    
    var loading: Bool = false
    var canLoadMore: Bool = false
    var isReload: Bool = true
    
    var limited: NSInteger = 20
    var page: NSInteger = 1
    
    var method: HTTPMethod = .get
    var url: String?
    var params: Dictionary<String, String>?
    
    typealias StartBlock = () -> ()
    typealias FinishedBlock = (_ data: Type?, _ error: NSError?) -> ()
    
    func load(start: StartBlock, finished: @escaping FinishedBlock) {
        if !loading {
            start()
            loading = true
            
            PHttpManager.requestAsynchronous(url: url!, method: method, parameters: params, completion: { (dic, error) in
                self.loading = false
                self.parse(source: dic["data"])
                finished(self.data, error)
            })
        }
    }
    func parse(source: AnyObject?) {
        if source is Array<Any> {
            
            let array = source as! Array<Any>
            
            canLoadMore = array.count >= limited
            var tmpData = self.data as? [Element]
            if tmpData == nil {
                tmpData = [Element]()
            }
            let tmp: [Element] = array.map({ (item) -> Element in
                return Element.toEntity(data: item)
            })
            
            if !isReload {
                tmpData?.append(contentsOf: tmp)
            } else {
                tmpData = tmp
            }
            self.data = tmpData as? Type
            
            if let key = cacheKey {
               let _ = PCacheManager.instance.setCache(cache: tmpData!, forKey: key)
            }
            
        } else if source is Dictionary<String, Any> {
            let entity = Element.toEntity(data: source)
            self.data = entity as? Type
            if let key = cacheKey {
                let _ = PCacheManager.instance.setCache(cache: entity, forKey: key)
            }
        } else {
            self.data = nil
        }
    }
}
