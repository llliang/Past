//
//  PTextViewController.swift
//  Past
//
//  Created by jiangliang on 2018/4/6.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PTextViewController: PBaseViewController, UITextViewDelegate {

    var placeholder: String?
    
    private var textView: PPlaceholderTextView?
    
    typealias DidBlock = (_ text: String) -> ()
    
    var didBlock: DidBlock?
    
    func didText(block: @escaping DidBlock) {
        didBlock = block
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView = PPlaceholderTextView(frame: CGRect(x: 0, y: 10, width: self.view.width, height: 120))
        textView?.font = PFont(size: 16)
        textView?.backgroundColor = UIColor.white
        textView?.returnKeyType = UIReturnKeyType.done
        textView?.delegate = self
        textView?.placeholder = placeholder
        self.view.addSubview(textView!)
    }

    func  textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            didBlock!(textView.text)
            self.navigationController?.popViewController(animated: true)
            return false
        }
        return true
    }
    
}
