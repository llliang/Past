//
//  StringExtention.swift
//  Past
//
//  Created by jiangliang on 2018/4/21.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import Foundation

extension String {
    func substring(fromIndex: Int) -> String {
        if fromIndex >= self.count {
            return ""
        }
        return String(self[self.index(self.startIndex, offsetBy: fromIndex)..<self.endIndex])
    }
    
    func substring(toIndex: Int) -> String {
        if toIndex >= self.count {
            return self
        }
        return String(self[self.startIndex..<self.index(self.startIndex, offsetBy: toIndex)])
    }
}
