//
//  PTextViewController.swift
//  Past
//
//  Created by jiangliang on 2018/4/6.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PTextViewController: PBaseViewController {

    var textView: PPlaceholderTextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView = PPlaceholderTextView(frame: CGRect(x: 0, y: 10, width: self.view.width, height: 120))
        textView?.font = PFont(size: 16)
        textView?.backgroundColor = UIColor.colorWithHex(hex: "")
        textView?.returnKeyType = UIReturnKeyType.done
        self.view.addSubview(textView!)
    }

}
