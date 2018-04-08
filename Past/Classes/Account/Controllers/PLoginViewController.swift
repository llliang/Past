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
    var mobileTextField: PTextField?
    var codeTextField: PTextField?
    var codeButton: UIButton?
    
    var timer: Timer?
    var countDownNumber: Int = 59
    
    deinit {
        self.invalidateTimer()
    }
    
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
        mobileTextField = PTextField(frame: CGRect(x: 32, y: label.bottom + 20, width: containerView!.width - 64, height: 44))
        mobileTextField?.backgroundColor = UIColor.colorWithHexAndAlpha(hex: "2acae7", alpha: 1)
        mobileTextField?.textColor = UIColor.white
        mobileTextField?.font = PFont(size: 14)
        mobileTextField?.placeholder = "手机号"
        mobileTextField?.keyboardType = .numberPad
        containerView?.addSubview(mobileTextField!)
        
        // 验证码
        codeTextField = PTextField(frame: CGRect(x: mobileTextField!.left, y: mobileTextField!.bottom + 10, width: mobileTextField!.width - 50, height: mobileTextField!.height))
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
    
    func invalidateTimer() {
        if timer != nil && (timer?.isValid)! {
            timer = nil
            timer?.invalidate()
        }
    }
    
    @objc func getCode() {
        
        if !self.validateMobile(mobile: mobileTextField?.text) {
            Hud.show(content: "请输入正确的手机号")
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        codeButton?.setTitle(String(countDownNumber), for: .normal)
        codeButton?.isUserInteractionEnabled = false
        
        PHttpManager.requestAsynchronous(url: "/mobile/sendCode", method: .get, parameters:["mobile": mobileTextField!.text!]) { dic, error in
            let code = dic["code"]?.int64Value
            if code != 200 {
                Hud.show(content: dic["message"] as! String)
            } else {
                Hud.show(content: "验证码已发送")
            }
        }
    }
    
    @objc func countDown() {
//        print("\(countDownNumber)")
        countDownNumber = countDownNumber - 1
        if countDownNumber <= 0 {
            codeButton?.setTitle("验证码", for: .normal)
            countDownNumber = 59
            timer?.invalidate()
            timer = nil
            codeButton?.isUserInteractionEnabled = true
        } else {
            codeButton?.setTitle(String(countDownNumber), for: .normal)
        }
    }
    
    func validateMobile(mobile: String?) -> Bool {
        guard let regEx = try? NSRegularExpression(pattern: "^1[3-9][0-9]{9}$", options: .caseInsensitive) else {
            return false
        }
        let count = regEx.numberOfMatches(in: mobile!, options: .reportProgress, range: NSMakeRange(0, mobile!.count))
        return count > 0;
    }
    
    func validateCode(code: String?) -> Bool {
        guard let regEx = try? NSRegularExpression(pattern: "^[0-9]{6}$", options: .caseInsensitive) else {
            return false
        }
        let count = regEx.numberOfMatches(in: code!, options: .reportProgress, range: NSMakeRange(0, code!.count))
        return count > 0;
    }
    
    @objc func login() {
        if !self.validateMobile(mobile: mobileTextField?.text) {
            Hud.show(content: "请输入正确的手机号")
            return
        }
        
        if !self.validateCode(code: codeTextField?.text) {
            Hud.show(content: "请输入正确的验证码")
            return
        }
   
        PHttpManager.requestAsynchronous(url: "/account/login", method: .post, parameters:["mobile":mobileTextField!.text!, "code": codeTextField!.text!]) { dic , error in
            let code = dic["code"]?.int64Value
            if code != 200 {
                Hud.show(content: dic["message"] as! String)
            } else {
                self.invalidateTimer()
                PUserSession.instance.updateSession(dic: dic["data"] as! Dictionary<String, Any>)
                NotificationCenter.default.post(name: PUserSessionChanged, object: nil, userInfo: nil)
            }
        }
    }
    
    @objc func lookupProtocol() {
        
    }
}
