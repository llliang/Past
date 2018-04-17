//
//  PSessionEntity.swift
//  Past
//
//  Created by jiangliang on 2018/3/29.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import Foundation

struct PSession: Entity {
    
    var token: String?
    var register: Bool = false
    var balance: Int = 0
    var user: PUser?
}
