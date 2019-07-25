//
//  Util.swift
//  Past
//
//  Created by jiangliang on 2018/3/25.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import Foundation
import UIKit

func PerformSelector(delay: Double,execute: @escaping ()->()){
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay){
        execute()
    }
}

class Util{
    
    class func window() -> UIWindow {
        return (UIApplication.shared.delegate as! AppDelegate).window!
    }
    
    class func getCurrentDeviceUUID() -> String{
        return (UIDevice.current.identifierForVendor?.uuidString)!
    }
    
    class func systemVersion() -> Float{
        return (UIDevice.current.systemVersion as NSString).floatValue
    }
    
    class func screenWidth() -> CGFloat{
        return UIScreen.main.bounds.width
    }
    
    class func screenHeight() -> CGFloat{
        return UIScreen.main.bounds.height
    }
    
    class func appVersion() -> String{
        let ver : Any? = Bundle.main.infoDictionary!["CFBundleShortVersionString"]
        return ver as! String
    }
    
    class func barButtonItem(image:UIImage, target: Any, action:Selector, imageEdgeInsets:UIEdgeInsets)->UIBarButtonItem{
        let button = Util.barButton(title: nil, target: target, action: action)
        button.imageEdgeInsets = imageEdgeInsets
        button.setImage(image, for: .normal)
        button.width = image.size.width+10
        button.height = 44
        button.isExclusiveTouch = true
        return UIBarButtonItem(customView: button)
    }
    
    class func barButtonItem(title: String, target: Any, action:Selector)->UIBarButtonItem{
        let button = Util.barButton(title: title, target: target, action: action)
        let titleSize = title.size(font: UIFont.systemFont(ofSize: 12), constrainedSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 44))
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.width = titleSize.width+10
        button.height = 44
        button.isExclusiveTouch = true
        return UIBarButtonItem(customView: button)
    }
    
    class func rasterizationScale() -> CGFloat{
        return UIScreen.main.scale
    }
    
    private class func barButton(title:String?, target:Any, action:Selector)->UIButton{
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        return button
    }
}

