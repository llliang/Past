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
    class func colorWith(hex:String) -> UIColor {
        return processColorWith(hex: hex, alpha: 1)
    }
    class func colorWith(hex:String, alpha:Float) -> UIColor {
        return processColorWith(hex: hex, alpha: alpha)
    }
    
    class private func processColorWith(hex:String, alpha:Float) -> UIColor {
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

extension UIColor {
    /// 标题颜色
    static var titleColor: UIColor = {
        return UIColor.colorWith(hex: "333333", alpha: 1)
    }()
    
    /// 正文颜色
    static var textColor: UIColor = {
        return UIColor.colorWith(hex: "666666", alpha: 1)
    }()
    
    /// 占位符颜色
    static var placeholderColor: UIColor = {
        return UIColor.colorWith(hex: "999999", alpha: 1)
    }()
    
    /// 自定义绿色
    static var greenColor: UIColor = {
        return UIColor.colorWith(hex: "0bcfe1", alpha: 0.9)
    }()
    
    /// 自定义红色
    static var redColor: UIColor = {
        return UIColor.colorWith(hex: "fa3d3d", alpha: 0.9)
    }()
}
