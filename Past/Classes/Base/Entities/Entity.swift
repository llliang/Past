//
//  Entity.swift
//  Past
//
//  Created by jiangliang on 2018/3/29.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import Foundation

protocol Entity: Codable {
    func toJson() -> Data?
    static func toEntity<T>(data: T) -> Self
}

extension Entity {
    func toJson() -> Data? {
        let encode = JSONEncoder()
        return try? encode.encode(self)
    }
    static func toEntity<T>(data: T) -> Self {
        let decoder = JSONDecoder()
        let objData = try? JSONSerialization.data(withJSONObject: data, options: JSONSerialization.WritingOptions.prettyPrinted)
        return try! decoder.decode(Self.self, from: objData!)
    }
}

extension Array: Entity where Element: Entity{
    
}


