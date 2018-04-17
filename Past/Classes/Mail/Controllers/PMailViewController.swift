//
//  PMailViewController.swift
//  Past
//
//  Created by jiangliang on 2018/4/8.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PMailViewController: PBaseViewController, PStampsViewDelegate {
  
    var sender: PUser?
    var addressee: PUser?
    
    var mail: PMail?
    
    enum EditStatus {
        // 读已有的信
        case reading
        /// 写信
        case editing
        /// 等待贴邮票
        case stamp
        /// 等待邮寄
        case waitingPost
    }
    
    var status: EditStatus = .editing

    var backView: UIView?
    var textView: PPlaceholderTextView?
    var signLabel: UILabel?
    
    // 信封
    var mailer: UIView?
    // 信封合上的部分
    var topOfMailer: UIImageView?
    // 信封底部
    var bottomOfMailer: UIImageView?
    
    // 贴上去的邮票
    var stampImageView: UIImageView?
    // 邮戳
    var postMarkImageView: UIImageView?
    
    // 选择邮票视图
    var stampsView: PStampsView?
    
    // 寄信选的邮票
    var stamp: PStamp?
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "给\(addressee?.nickname ?? "")的信"
        
        self.layoutMailContent()

        if status != .reading {
            // 信封
            self.layoutMailer()
            
            // 邮票选择UI
            self.layoutStamps()
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "塞入信封", style: .right, target: self, action: #selector(putIntoMailer))
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            
            // 加载用户拥有的邮票
            self.loadStamps()
        } else {
            self.loadMailDetail()
        }
    }
    
    func layoutMailContent() {
        
        backView = UIView(frame: CGRect(x: 0, y: 10, width: self.view.width, height: self.view.height))
        self.view.addSubview(backView!)
        
        textView = PPlaceholderTextView(frame: CGRect(x: 0, y: 0, width: backView!.width, height: 240))
        textView?.autoresizingMask = .flexibleHeight
        textView?.backgroundColor = UIColor.clear
        textView?.contentInset = UIEdgeInsetsMake(10, 10, 0, 10)
        textView?.font = PFont(size: 16)
        self.setTextViewContent(addressee: addressee!, content: nil)
        backView?.addSubview(textView!)
        
        signLabel = UILabel(frame: CGRect(x: 16, y: textView!.bottom, width: self.view.width - 32, height: 80))
        signLabel?.numberOfLines = 0
        signLabel?.autoresizingMask = .flexibleTopMargin
        signLabel?.font = PFont(size: 16)
        signLabel?.textAlignment = .right
        self.setSign(name: PUserSession.instance.session?.user?.nickname, date: Date())
        backView?.addSubview(signLabel!)
        
        textView?.becomeFirstResponder()
    }
    
    func layoutMailer() {
        
        let width: CGFloat = self.view.width
        let rate = width/468
        mailer = UIView(frame: CGRect(x: 0, y: self.view.height, width: width, height: rate*325))
        mailer?.isHidden = true
        self.view.addSubview(mailer!)
        
        topOfMailer = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: rate*80))
        topOfMailer?.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        topOfMailer?.center = CGPoint(x: width/2, y: rate*80)
        topOfMailer?.image = UIImage(named: "mail_envelope_top")
        mailer?.addSubview(topOfMailer!)
        
        bottomOfMailer = UIImageView(frame: CGRect(x: 0, y: topOfMailer!.bottom, width: width, height: rate*245))
        bottomOfMailer?.image = UIImage(named: "mail_envelope_bottom")
        mailer?.addSubview(bottomOfMailer!)
        
        // 收信人邮编
        for i in 0..<6 {
            let label = UILabel(frame: CGRect(x: 10 + (16 + 5)*i, y: 20, width: 16, height: 16))
            label.layer.borderColor = UIColor.darkGray.cgColor
            label.font = PFont(size: 14)
            label.layer.borderWidth = 1
            label.textAlignment = .center
            bottomOfMailer?.addSubview(label)
            label.text = String(i + 1)
        }
        
        // 邮票张贴区域
        let zone = UIImageView(frame: CGRect(x: width - 100, y: 10, width: 80, height: 48))
        zone.image = UIImage(named: "mail_envelope_stampZone")
        bottomOfMailer?.addSubview(zone)
        
        stampImageView = UIImageView(frame: CGRect(x: 40, y: 0, width: 40, height: 48))
        stampImageView?.layer.masksToBounds = true
        stampImageView?.contentMode = .scaleAspectFill
        zone.addSubview(stampImageView!)
        
        postMarkImageView = UIImageView(image: UIImage(named: "mail_envelope_passed"))
        postMarkImageView?.width = 40
        postMarkImageView?.height = 36
        postMarkImageView?.isHidden = true
        postMarkImageView?.center = CGPoint(x: zone.width/2, y: zone.height/2)
        zone.addSubview(postMarkImageView!)
        
        let receiverLabel = UILabel(frame: CGRect(x: 80, y: bottomOfMailer!.height/2 - 40, width: bottomOfMailer!.width - 160, height: 40))
        receiverLabel.font = PFont(size: 16)
        receiverLabel.text = "收信人：XXX"
        bottomOfMailer?.addSubview(receiverLabel)
        
        let senderLabel = UILabel(frame: CGRect(x: bottomOfMailer!.width - 100, y: bottomOfMailer!.height - 50, width: 80, height: 40))
        senderLabel.font = PFont(size: 16)
        senderLabel.textAlignment = .right
        senderLabel.text = "XXX"
        bottomOfMailer?.addSubview(senderLabel)
        
//        for i in 0..<6 {
//            let label = UILabel(frame: CGRect(x:Int(bottomOfMailer!.width)  - 226 + (16 + 5)*i, y: Int(bottomOfMailer!.height - 38), width: 16, height: 16))
//            label.layer.borderColor = UIColor.darkGray.cgColor
//            label.font = PFont(size: 14)
//            label.layer.borderWidth = 1
//            label.textAlignment = .center
//            bottomOfMailer?.addSubview(label)
//            label.text = String(i + 1)
//        }
    }
    
    func layoutStamps() {
        
        stampsView = PStampsView(frame: CGRect(x: 0, y: self.view.height - 120, width: self.view.width, height: 120))
        stampsView?.backgroundColor = UIColor.white
        stampsView?.autoresizingMask = .flexibleTopMargin
        stampsView?.stampDelegate = self
        self.view.addSubview(stampsView!)
    }
    
    func loadMailDetail() {
//        let mailModel = PDataModel<PMail, PMail>()
//        mailModel.url = "/mail/detail"
//        mailModel.load(start: {
//
//        }) { (mail, error) in
//            self.setTextViewContent(addressee: (mail?.addressee)! ,content: mail?.content)
//            self.textView?.sizeToFit()
//            if #available(iOS 11.0, *) {
//                self.textView?.height = min(self.view.height - self.view.safeAreaInsets.bottom - self.signLabel!.height, self.textView!.height)
//            } else {
//                self.textView?.height = min(self.view.height - self.signLabel!.height, self.textView!.height)
//            }
//            self.setSign(name: mail?.sender.nickname, date: Date(timeIntervalSince1970: TimeInterval(mail!.time)))
//            self.signLabel?.top = self.textView!.bottom
//        }
        
        self.setTextViewContent(addressee: (mail?.addressee)! ,content: mail?.content)
        self.textView?.height = self.textView!.sizeThatFits(CGSize(width: self.view.width, height: CGFloat.greatestFiniteMagnitude)).height
        
        if #available(iOS 11.0, *) {
//            self.textView?.height = min(self.view.height - self.view.safeAreaInsets.bottom - self.signLabel!.height, self.textView!.height)
            
            if self.view.height - self.view.safeAreaInsets.bottom - self.signLabel!.height <= self.textView!.height {
                self.textView?.height = self.view.height - self.view.safeAreaInsets.bottom - self.signLabel!.height
            } else {
                
                self.textView?.isScrollEnabled = false
            }
            
        } else {
//            self.textView?.height = min(self.view.height - self.signLabel!.height, self.textView!.height)
            if self.view.height - self.signLabel!.height <= self.textView!.height {
                self.textView?.height = self.view.height - self.signLabel!.height
            } else {
                self.textView?.isScrollEnabled = false
            }
        }
        self.setSign(name: mail?.sender.nickname, date: Date(timeIntervalSince1970: TimeInterval(mail!.time)))
        self.signLabel?.top = self.textView!.bottom
        self.textView?.isEditable = false
    }
    
    func setTextViewContent(addressee: PUser, content: String?) {
        self.textView?.text = """
        \(addressee.nickname ?? ""):
            \(content ?? "")
        """
        if let c = content {
            self.textView?.text = c
        } else {
            self.textView?.text = """
            \(addressee.nickname ?? ""):
                \("")
            """
        }
    }
    
    func setSign(name: String?, date: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年M月d日"
        
        signLabel?.text = """
        \(name ?? "")
        \(dateFormatter.string(from: date))
        """
    }
    
    func loadStamps() {
        
        let stampModel = PDataModel<PStamp, [PStamp]>()
        stampModel.url = "/stamp/stamp"
        stampModel.limited = 1000
        
        stampModel.load(start: {
            
        }, finished: { (s, error) in
            self.stampsView?.stamps = s
        })
    }
    
    @objc func putIntoMailer() {
        
        if  status == .editing {
            textView?.resignFirstResponder()
            
            UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveLinear, animations: {
                self.backView?.frame = CGRect(x: 0, y: 200 + self.topOfMailer!.height, width: self.view!.width, height: self.bottomOfMailer!.height)
                self.mailer?.isHidden = false
                self.mailer?.top = 200
            }) { (finished) in
                UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveLinear, animations: {
                    self.topOfMailer?.layer.transform = CATransform3DMakeRotation(-CGFloat(Double.pi), -1, 0, 0)
                }, completion: { (finished) in
                    self.status = .stamp
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "投寄", style: .right, target: self, action: #selector(self.putIntoMailer))
                })
            }
        } else if status == .stamp {
            Hud.show(content: "请贴邮票")
        } else if status == .waitingPost {
            self.post()
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let rect = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect
        backView?.height = self.view.height - 10 - rect.height
        signLabel!.top = backView!.height - signLabel!.height
        textView!.height = signLabel!.top - 20
        
        mailer?.top = self.view.height - rect.height
    }
    
    func stampClicked(stamp: PStamp) {
        stampImageView?.kf.setImage(with: URL(string: (stamp.image)!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, type, url) in
            self.postMarkImageView?.isHidden = false
            self.stamp = stamp
            self.status = .waitingPost
        })
    }
    
    func post() {
        var params = Dictionary<String, Any>()
//        params["sender"] = String((PUserSession.instance.session?.user?.userId)!)
//        params["addressee"] = String((addressee?.userId)!)
//        params["stamp"] = String((stamp?.id)!)
//        params["content"] = textView?.text
        
        params["sender"] = PUserSession.instance.session?.user?.userId
        params["addressee"] = addressee?.userId
        params["stamp"] = stamp?.id
        params["content"] = textView?.text
        
        PHttpManager.requestAsynchronous(url: "/mail/post", method: .post, parameters: params) { result in
            if result.error == nil {
                if result.code == 200 {
                    Hud.show(content: "邮件已发送")
                    self.navigationController?.popViewController(animated: true)
                } else {
                    Hud.show(content: result.message)
                }
            } else {
                Hud.show(content: result.error!.description)
            }
        }
    }
}
