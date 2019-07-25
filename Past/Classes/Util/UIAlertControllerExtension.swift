//
//  UIAlertControllerExtension.swift
//  Past
//
//  Created by jiangliang on 2018/4/14.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    convenience init(title: String?, message: String?, actions: [String]?, cancel: String?, preferredStyle: UIAlertController.Style, handle: @escaping (_ index: Int) -> ()) {
        
        self.init(title: title, message: message, preferredStyle: preferredStyle)
  
        if let acs = actions {
            for (idx, title) in acs.enumerated() {
                let action = UIAlertAction(title: title, style: .default) { (_) in
                    handle(idx)
                }
                action.setValue(UIColor.greenColor, forKey: "titleTextColor")
                self.addAction(action)
            }
        }
        
        if let cancelTitle = cancel {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (_) in
                
            }
            cancelAction.setValue(UIColor.greenColor, forKey: "titleTextColor")
            self.addAction(cancelAction)
        }
    }
}
