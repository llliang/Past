
//  PConstants.swift
//  Past
//
//  Created by jiangliang on 2018/3/22.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import Foundation
import UIKit

func PFont(size: CGFloat) -> UIFont? {
//    return UIFont.systemFont(ofSize: size)
    return  UIFont(name: "STXingkaiSC-Light", size: size)       // 行楷
//    return  UIFont(name: "STLiti", size: size)                  // 隶书
//    return  UIFont(name: "STXinwei", size: size)                // 新魏
//    return  UIFont(name: "FZKTJW--GB1-0", size: size)           // 楷体
}

func printFonts() {
    let array = UIFont.familyNames
    for fname in array {
//        continue
        let names = UIFont.fontNames(forFamilyName: fname)
        for name in names {
            print("fname = \(fname)---name = \(name)")
        }
    }
}
