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
        self.layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func layoutSubviews() {
        containerView = UIView(frame: CGRect(x: 0, y: 80, width: self.view.width, height: 200))
        self.view.addSubview(containerView!)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: containerView!.width, height: 80))
        label.font = PFont(size: 20)
        label.numberOfLines = 0
        let text = """
        昔我往矣 杨柳依依
        今我来思 雨雪霏霏
        """
        let attr = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        attr.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSMakeRange(0, attr.length))
        label.textColor = UIColor.titleColor
        label.attributedText = attr
        label.textAlignment = .center
        containerView?.addSubview(label)
        // 手机号
        mobileTextField = PTextField(frame: CGRect(x: 32, y: label.bottom + 40, width: containerView!.width - 64, height: 44))
        mobileTextField?.backgroundColor = UIColor.greenColor
        mobileTextField?.layer.cornerRadius = 8
        mobileTextField?.layer.masksToBounds = true
        mobileTextField?.textColor = UIColor.white
        mobileTextField?.font = PFont(size: 16)
        mobileTextField?.placeholder = "手机号"
        mobileTextField?.keyboardType = .numberPad
        mobileTextField?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        containerView?.addSubview(mobileTextField!)
        
        // 验证码
        codeTextField = PTextField(frame: CGRect(x: mobileTextField!.left, y: mobileTextField!.bottom + 10, width: mobileTextField!.width, height: mobileTextField!.height))
        codeTextField?.backgroundColor = UIColor.greenColor
        codeTextField?.layer.cornerRadius = 8
        codeTextField?.layer.masksToBounds = true
        codeTextField?.textColor = UIColor.white
        codeTextField?.font = PFont(size: 16)
        codeTextField?.placeholder = "验证码"
        codeTextField?.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        codeTextField?.keyboardType = .numberPad
        containerView?.addSubview(codeTextField!)
        
        // 获取验证码button
        codeButton = UIButton(frame: CGRect(x: codeTextField!.right - 80, y: codeTextField!.top, width: 70, height: codeTextField!.height))
        codeButton?.setTitle("获取验证码", for: .normal)
        codeButton?.contentHorizontalAlignment = .right
        codeButton?.titleLabel?.font = PFont(size: 14)
        codeButton?.setTitleColor(UIColor.white, for: .normal)
        codeButton?.addTarget(self, action: #selector(getCode), for: .touchUpInside)
        containerView?.addSubview(codeButton!)
        
        let loginBtn = UIButton(frame: CGRect(x: 32, y: codeTextField!.bottom + 20, width: containerView!.width - 64, height: 44))
        loginBtn.backgroundColor = UIColor.greenColor
        loginBtn.layer.cornerRadius = 8
        loginBtn.layer.masksToBounds = true
        loginBtn.titleLabel?.font = PFont(size: 16)
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
        protocolBtn.setTitleColor(UIColor.greenColor, for: .normal)
        protocolBtn.addTarget(self, action: #selector(lookupProtocol), for: .touchUpInside)
        
//        protocolLabel.left = (containerView!.width - (prefixWidth + suffixWidth)) / 2.0
        protocolLabel.width = prefixWidth
        protocolBtn.left = protocolLabel.right
        protocolBtn.width = suffixWidth
        containerView?.height = protocolLabel.bottom
        
        let visitorBtn = UIButton(frame: CGRect(x: containerView!.width - 32 - 60, y: protocolBtn.top, width: 60, height: protocolBtn.height))
        visitorBtn.titleLabel?.font = protocolLabel.font
        visitorBtn.setTitleColor(UIColor.greenColor, for: .normal)
        visitorBtn.setTitle("游客登录", for: .normal)
        visitorBtn.contentHorizontalAlignment = .right
        visitorBtn.addTarget(self, action: #selector(visitorLogin), for: .touchUpInside)
        containerView?.addSubview(visitorBtn)
        
        containerView?.center = CGPoint(x: self.view.width/2.0, y: self.view.height/2.0 - 150)
    }
    
    func invalidateTimer() {
        if timer != nil && (timer?.isValid)! {
            timer = nil
            timer?.invalidate()
        }
    }
    
    @objc func getCode(btn: UIButton) {
        
        if !self.validateMobile(mobile: mobileTextField?.text) {
            Hud.show(content: "请输入正确的手机号")
            return
        }
        btn.isUserInteractionEnabled = false
        PHttpManager.requestAsynchronous(url: "/mobile/sendCode", method: .get, parameters:["mobile": mobileTextField!.text!]) { result in
            if let error = result.error {
                Hud.show(content: error.domain)
                btn.isUserInteractionEnabled = true
                return
            }
            if result.code != 200 {
                btn.isUserInteractionEnabled = true
                Hud.show(content: result.message)
                
            } else {
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
                self.codeButton?.setTitle(String(self.countDownNumber), for: .normal)
                
                Hud.show(content: "验证码已发送")
            }
        }
    }
    
    @objc func countDown() {
//        print("\(countDownNumber)")
        countDownNumber = countDownNumber - 1
        if countDownNumber <= 0 {
            codeButton?.setTitle("获取验证码", for: .normal)
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
    
    @objc func login(btn: UIButton) {
        
        if !self.validateMobile(mobile: mobileTextField?.text) {
            Hud.show(content: "请输入正确的手机号")
            return
        }
        
        if !self.validateCode(code: codeTextField?.text) {
            Hud.show(content: "请输入正确的验证码")
            return
        }
        
        btn.isUserInteractionEnabled = false
        
        PHttpManager.requestAsynchronous(url: "/account/login", method: .post, parameters:["mobile":mobileTextField!.text!, "code": codeTextField!.text!]) { result in
            btn.isUserInteractionEnabled = true
            if result.error != nil {
                Hud.show(content: (result.error?.description)!)
                return
            }
            if result.code != 200 {
                Hud.show(content: result.message)
            } else {
                self.invalidateTimer()
                PUserSession.instance.updateSession(dic: result.data! as! Dictionary<String, Any>)
                if (PUserSession.instance.session?.register)! {
                    let profileController = PProfileViewController()
                    profileController.user = PUserSession.instance.session?.user
                    profileController.title = "完善个人信息"
                    let navController = PNavigationController(rootViewController: profileController)
                    self.present(navController, animated: true, completion: nil)
                } else {
                    NotificationCenter.default.post(name: PUserSessionChanged, object: nil, userInfo: nil)
                }
                self.setJPUSHAlias(userId: PUserSession.instance.session!.user!.userId)
            }
        }
    }
    
    @objc func visitorLogin(btn: UIButton) {
        btn.isUserInteractionEnabled = false
        PHttpManager.requestAsynchronous(url: "/account/visitorLogin", method: .post, parameters: nil) { result in
            btn.isUserInteractionEnabled = true
            if result.error != nil {
                Hud.show(content: (result.error?.description)!)
                return
            }
            if result.code != 200 {
                Hud.show(content: result.message)
            } else {
                PUserSession.instance.updateSession(dic: result.data! as! Dictionary<String, Any>)
                if (PUserSession.instance.session?.register)! {
                    let profileController = PProfileViewController()
                    profileController.user = PUserSession.instance.session?.user
                    profileController.title = "完善个人信息"
                    let navController = PNavigationController(rootViewController: profileController)
                    self.present(navController, animated: true, completion: nil)
                } else {
                    NotificationCenter.default.post(name: PUserSessionChanged, object: nil, userInfo: nil)
                }
                
                self.setJPUSHAlias(userId: PUserSession.instance.session!.user!.userId)
            }
        }
    }
    
    func setJPUSHAlias(userId: Int) {
        JPUSHService.setAlias("wx_\(userId)", completion: { (iResCode, iAlias, req) in
            
        }, seq: userId)
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        if let text = textField.text {
            if textField == mobileTextField {
                if text.count > 11 {
                    textField.text = text.substring(toIndex: 11)
                }
            } else {
                if text.count > 6 {
                    textField.text = text.substring(toIndex: 6)
                }
            }
        }
    }
    
    @objc func lookupProtocol() {
        let webController = PWebViewController()
        webController.url = PConfigManager.manager.value(forKey: "userProtocol")
        webController.title = "用户协议"
        self.navigationController?.pushViewController(webController, animated: true)
    }
}
