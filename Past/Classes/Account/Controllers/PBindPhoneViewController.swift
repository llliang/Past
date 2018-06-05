//
//  PBindPhoneViewController.swift
//  Past
//
//  Created by jiangliang on 2018/5/8.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PBindPhoneViewController: PBaseViewController {

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
        
        // 手机号
        mobileTextField = PTextField(frame: CGRect(x: 32, y: 40, width: containerView!.width - 64, height: 44))
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
        loginBtn.setTitle("绑定", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.addTarget(self, action: #selector(bindPhone), for: .touchUpInside)
        containerView?.addSubview(loginBtn)
        
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
        
        PHttpManager.requestAsynchronous(url: "/mobile/sendBindCode", method: .get, parameters:["mobile": mobileTextField!.text!]) { result in
            
            if result.code != 200 {
                Hud.show(content: result.message)
            } else {
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
                self.codeButton?.setTitle(String(self.countDownNumber), for: .normal)
                self.codeButton?.isUserInteractionEnabled = false
                
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
    
    @objc func bindPhone() {
        if !self.validateMobile(mobile: mobileTextField?.text) {
            Hud.show(content: "请输入正确的手机号")
            return
        }
        
        if !self.validateCode(code: codeTextField?.text) {
            Hud.show(content: "请输入正确的验证码")
            return
        }
        
        PHttpManager.requestAsynchronous(url: "/account/bind", method: .post, parameters:["mobile":mobileTextField!.text!, "code": codeTextField!.text!]) { result in
            if result.error != nil {
                Hud.show(content: (result.error?.description)!)
                return
            }
            if result.code != 200 {
                Hud.show(content: result.message)
            } else {
                self.invalidateTimer()
                PUserSession.instance.updateSession(dic: result.data! as! Dictionary<String, Any>)
                
                let alertController = UIAlertController(title: nil, message: "绑定成功，以后可用该手机号登录该账号", actions: ["我知道了"], cancel: nil, preferredStyle: UIAlertControllerStyle.alert, handle: { (index) in
                    self.navigationController?.popViewController(animated: true)
                })
                self.present(alertController, animated: true, completion: nil)
            }
        }
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
    
}
