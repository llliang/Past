//
//  PCacheManager.swift
//  Past
//
//  Created by jiangliang on 2018/3/28.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit
import Foundation
import SQLite

class PCacheManager: NSObject {
    
    static let instance = PCacheManager()
    
    let key = Expression<String>("key")
    let data = Expression<String>("data")
    let expire = Expression<Date>("expire")
    
    override init() {
        super.init()
       _ = try? db?.run(kvTable.create(ifNotExists: false, block: { (t) in
            t.column(key, primaryKey: true)
            t.column(data)
            t.column(expire)
        }))
        
      _ = try? db?.run(kvTable.filter(expire < Date()).delete())
    }
       
     lazy var db: Connection? = {
        let documentPath: NSString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        let path = documentPath.appendingPathComponent("cache") as String
        print("path = \(path)")
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: path) {
           try? fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        
        return try? Connection(path + "/db.sqlite3")
    }()
    // 键值对数据库
    var kvTable = Table("kvTable")
    
//    func setCache(cache: String, forKey: String) -> Bool {
//        do {
//            try db?.run(kvTable.insert(or: .replace, key <- forKey, data <- cache, expire <- Date()))
//            return true
//        } catch  {
//            print(error)
//            return false
//        }
//    }
    
    @discardableResult func setCache<T: Entity>(cache: T, forKey: String) -> Bool {
        let d = cache.toJson()
        let string = String(data: d!, encoding: String.Encoding.utf8)
        do {
            try db?.run(kvTable.insert(or: .replace, key <- forKey, data <- string!, expire <- Date().addingTimeInterval(60*60*24*7)))
            return true
        } catch  {
            print(error)
            return false
        }
    }
    
    func removeCache(forKey: String) {
        do {
            try db?.run(kvTable.filter(key == forKey).delete())
        } catch {
            print(error)
        }
    }
    
    func cache<T: Codable>(forKey: String) -> T? {
        let read = kvTable.filter(key == forKey)
        var results = Array<Row>()
        for item in (try! db?.prepare(read))! {
            results.append(item)
        }
        
        let string: String? = results.first?[data]
        
        if (string != nil) {
            return try? JSONDecoder().decode(T.self, from: (string?.data(using: String.Encoding.utf8))!)
        }
        return nil
    }
}
