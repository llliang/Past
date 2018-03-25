//
//  UIColorExtension.swift
//  Past
//
//  Created by jiangliang on 2018/3/22.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func colorWithHex(hex:String) -> UIColor {
        return processColorWithHexAndAlpha(hex: hex, alpha: 1)
    }
    class func colorWithHexAndAlpha(hex:String, alpha:Float) -> UIColor {
        return processColorWithHexAndAlpha(hex: hex, alpha: alpha)
    }
    
    class private func processColorWithHexAndAlpha(hex:String, alpha:Float) -> UIColor {
        if hex.isEmpty {
            return UIColor(white: 0, alpha: CGFloat(alpha))
        }
        var tempHex = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if tempHex.count < 6 {
            
            return UIColor.clear
        }
        
        if tempHex.hasPrefix("0X") {
            tempHex = String(tempHex["0X".endIndex...])
        }
        if tempHex.hasPrefix("#") {
            tempHex = tempHex.replacingOccurrences(of: "#", with: "")
        }
        if tempHex.count<6 {
            return UIColor.clear
        }
        let rHex = String(tempHex[..<tempHex.index(tempHex.startIndex, offsetBy: 2)])
        
        let gHex = String(tempHex[Range.init(uncheckedBounds: (tempHex.index(tempHex.startIndex, offsetBy: 2),tempHex.index(tempHex.startIndex, offsetBy: 4)))])
        
        let bHex = String(tempHex[tempHex.index(tempHex.startIndex, offsetBy: 4)...])
        
        var r: UInt32 = 0,g: UInt32 = 0 ,b: UInt32 = 0
        
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(alpha))
    }
}
