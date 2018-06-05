//
//  PLetter.swift
//  Past
//
//  Created by jiangliang on 2018/4/12.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

struct PLetter: Entity {
    var id: Int
    var sender: PUser
    var addressee: PUser
//    var stamp: PStamp
    var content: String
    var time: Int
    var receivingTime: Int
    var status: Int
}
