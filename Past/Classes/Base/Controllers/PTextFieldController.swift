//
//  PTextFieldViewController.swift
//  Past
//
//  Created by jiangliang on 2018/4/6.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PTextFieldController: PBaseViewController, UITextFieldDelegate {
    
    var textField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        let backView = UIView(frame: CGRect(x: 0, y: 10, width: self.view.width, height: 44))
        backView.backgroundColor = UIColor.white
        self.view.addSubview(backView)
        
        textField = UITextField(frame: CGRect(x: 16, y: 0, width: backView.width - 32, height: backView.height))
        textField?.font = PFont(size: 16)
        textField?.textColor = UIColor.darkGray
        textField?.clearButtonMode = UITextFieldViewMode.whileEditing
        textField?.becomeFirstResponder()
        textField?.returnKeyType = UIReturnKeyType.done
        textField?.enablesReturnKeyAutomatically = true
        backView.addSubview(textField!)
        
        textField?.delegate = self
    }
    
    typealias DidBlock = (_ text: String) -> ()
    
    var didBlock: DidBlock?
    
    func didText(block: @escaping DidBlock) {
        didBlock = block
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        didBlock!(textField.text!)
        self.dismiss(animated: true, completion: nil)
        return true
    }
}
