//
//  PTextField.swift
//  Past
//
//  Created by jiangliang on 2018/3/22.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PTextField: UITextField {
   
    override var placeholder: String? {
        didSet {
            if let holder = placeholder {
                let attributedString = NSMutableAttributedString(string: holder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                self.attributedPlaceholder = attributedString
            }
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 2)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 2)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 2)
    }
}
