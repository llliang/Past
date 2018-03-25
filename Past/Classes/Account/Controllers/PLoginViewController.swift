//
//  PLoginViewController.swift
//  Past
//
//  Created by jiangliang on 2018/3/22.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PLoginViewController: PBaseViewController {

    var containerView: UIView?
    var phoneTextField: PTextField?
    var codeTextField: PTextField?
    var codeButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorWithHex(hex: "f3f3f3")
        self.layoutSubviews()
    }
    
    func layoutSubviews() {
        containerView = UIView(frame: CGRect(x: 0, y: 100, width: self.view.width, height: 200))
        self.view.addSubview(containerView!)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: containerView!.width, height: 60))
        label.font = PFont(size: 14)
        label.numberOfLines = 0
        let text = """
        昔我往矣 杨柳依依
        今我来思 雨雪霏霏
        """
        let attr = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        attr.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSMakeRange(0, attr.length))
        
        label.attributedText = attr
        label.textAlignment = .center
        containerView?.addSubview(label)
        // 手机号
        phoneTextField = PTextField(frame: CGRect(x: 32, y: label.bottom + 20, width: containerView!.width - 64, height: 44))
        phoneTextField?.backgroundColor = UIColor.colorWithHexAndAlpha(hex: "2acae7", alpha: 1)
        phoneTextField?.textColor = UIColor.white
        phoneTextField?.font = PFont(size: 14)
        phoneTextField?.placeholder = "手机号"
        phoneTextField?.keyboardType = .numberPad
        containerView?.addSubview(phoneTextField!)
        
        // 验证码
        codeTextField = PTextField(frame: CGRect(x: phoneTextField!.left, y: phoneTextField!.bottom + 10, width: phoneTextField!.width - 50, height: phoneTextField!.height))
        codeTextField?.backgroundColor = UIColor.colorWithHexAndAlpha(hex: "2acae7", alpha: 1)
        codeTextField?.textColor = UIColor.white
        codeTextField?.font = PFont(size: 14)
        codeTextField?.placeholder = "验证码"
        codeTextField?.keyboardType = .numberPad
        containerView?.addSubview(codeTextField!)
        
        // 获取验证码button
        codeButton = UIButton(frame: CGRect(x: codeTextField!.right, y: codeTextField!.top + 5, width: 60, height: codeTextField!.height - 10))
        codeButton?.setTitle("验证码", for: .normal)
        codeButton?.titleLabel?.font = PFont(size: 12)
        codeButton?.setTitleColor(UIColor.darkText, for: .normal)
        codeButton?.addTarget(self, action: #selector(getCode), for: .touchUpInside)
        containerView?.addSubview(codeButton!)
        
        let loginBtn = UIButton(frame: CGRect(x: 32, y: codeTextField!.bottom + 10, width: containerView!.width - 64, height: 44))
        loginBtn.backgroundColor = UIColor.colorWithHex(hex: "2acae7")
        loginBtn.titleLabel?.font = PFont(size: 14)
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.addTarget(self, action: #selector(login), for: .touchUpInside)
        containerView?.addSubview(loginBtn)
        
        let protocolLabel = UILabel(frame: CGRect(x: 32, y: loginBtn.bottom + 10, width: loginBtn.width, height: 20))
        protocolLabel.font = PFont(size: 14)
        protocolLabel.textAlignment = .center
        containerView?.addSubview(protocolLabel)
        let prefixString = NSString(string: "登录代表接受")
        let prefixWidth = prefixString.size(withFont: protocolLabel.font, constrainedSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: protocolLabel.height)).width
        protocolLabel.text = prefixString as String
        
        let suffixString = NSString(string: "用户协议")
        let suffixWidth = suffixString.size(withFont: protocolLabel.font, constrainedSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: protocolLabel.height)).width
        let protocolBtn = UIButton(frame: CGRect(x: 0, y: protocolLabel.top, width: suffixWidth, height: protocolLabel.height))
        containerView?.addSubview(protocolBtn)
        protocolBtn.titleLabel?.font = protocolLabel.font
        protocolBtn.setTitle(suffixString as String, for: .normal)
        protocolBtn.setTitleColor(UIColor.colorWithHex(hex: "2acae7"), for: .normal)
        protocolBtn.addTarget(self, action: #selector(lookupProtocol), for: .touchUpInside)
        
        protocolLabel.left = (containerView!.width - (prefixWidth + suffixWidth)) / 2.0
        protocolLabel.width = prefixWidth
        protocolBtn.left = protocolLabel.right
        protocolBtn.width = suffixWidth
        containerView?.height = protocolLabel.bottom
        
        containerView?.center = CGPoint(x: self.view.width/2.0, y: self.view.height/2.0 - 150)
    }
    
    @objc func getCode() {
        
    }
    
    @objc func login() {
        
    }
    
    @objc func lookupProtocol() {
        
    }
}
