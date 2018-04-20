//
//  PMailViewController.swift
//  Past
//
//  Created by jiangliang on 2018/4/8.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PMailViewController: PBaseViewController, PStampsViewDelegate, UITextViewDelegate {
  
    var sender: PUser?
    var addressee: PUser?
    
    // 若在查看信件状态下 判断是否是收信人
    var isSender: Bool = false
    
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
        self.view.backgroundColor = UIColor.white
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
            isSender = (sender?.userId == PUserSession.instance.session?.user?.userId)
            
            var rightTitle: String
            if isSender {
                rightTitle = "再写一封"
            } else {
                rightTitle = "回复"
            }
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightTitle, style: .right, target: self, action: #selector(writeMail))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if status == .reading {
            self.layoutMailDetail()
        }
    }
    
    func layoutMailContent() {
        
        if status != .reading {
            backView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height))
            backView?.autoresizingMask = .flexibleHeight
            self.view.addSubview(backView!)
        } else {
            backView = self.view
        }
        
        textView = PPlaceholderTextView(frame: CGRect(x: 0, y: 0, width: backView!.width, height: 0))
        textView?.autoresizingMask = .flexibleHeight
        textView?.delegate = self
        textView?.backgroundColor = UIColor.clear
        textView?.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)
        textView?.font = PFont(size: 16)
        backView?.addSubview(textView!)

        self.setTextViewContent(addressee: addressee!, content: nil)
        
        signLabel = UILabel(frame: CGRect(x: 16, y: textView!.bottom, width: self.view.width - 32, height: 60))
        signLabel?.autoresizingMask = .flexibleTopMargin
        signLabel?.numberOfLines = 0
        signLabel?.font = PFont(size: 16)
        signLabel?.textAlignment = .right
        backView?.addSubview(signLabel!)
        
        self.setSign(name: PUserSession.instance.session?.user?.nickname, date: Date())

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
            label.layer.borderColor = UIColor.titleColor.cgColor
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
    
    func layoutMailDetail() {
        
        self.setTextViewContent(addressee: (mail?.addressee)! ,content: mail?.content)
        
        self.textView?.height = self.textView!.sizeThatFits(CGSize(width: self.view.width - self.textView!.contentInset.left - self.textView!.contentInset.right, height: CGFloat.greatestFiniteMagnitude)).height
        
        if self.backView!.height - self.signLabel!.height  <= self.textView!.height {
            self.textView?.height = self.backView!.height - self.signLabel!.height
        } else {
            self.textView?.isUserInteractionEnabled = false
        }
        
        self.setSign(name: mail?.sender.nickname, date: Date(timeIntervalSince1970: TimeInterval(mail!.time)))
        self.signLabel?.top = self.textView!.bottom
        self.textView?.isEditable = false
    }

    override func viewSafeAreaInsetsDidChange() {
        
        if #available(iOS 11.0, *) {
            self.textView?.height = min(self.view.height - self.view.safeAreaInsets.bottom - self.view.safeAreaInsets.top - self.signLabel!.height, self.textView!.height)
            if self.view.height - self.view.safeAreaInsets.bottom - self.view.safeAreaInsets.top - self.signLabel!.height <= self.textView!.height {
                self.textView?.isUserInteractionEnabled = true
            } else {
                self.textView?.isUserInteractionEnabled = false
            }
        }
         self.signLabel?.top = self.textView!.bottom
    }
    
    func setTextViewContent(addressee: PUser, content: String?) {
    
//        if let c = content {
//            self.textView?.text = c
//        } else {
//            self.textView?.text = """
//            \(addressee.nickname ?? ""):
//                \(content ?? "")
//            """
//        }
        
        self.textView?.text = """
        \(addressee.nickname ?? ""):
            \(content ?? "")
        """
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
            
            if self.clip(content: textView!.text).count == 0 {
                Hud.show(content: "请书写信件内容")
                return
            }
            
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
        print("\(rect.height)")
        backView?.height = self.view.height - rect.height
        signLabel!.top = backView!.height - signLabel!.height
        textView!.height = signLabel!.top
        
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
        params["sender"] = PUserSession.instance.session?.user?.userId
        params["addressee"] = addressee?.userId
        params["stamp"] = stamp?.id
        params["content"] = self.clip(content: textView!.text)
        
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == "\(addressee!.nickname!):" && text == "" {
            return false
        }
        return true
    }
    
    func clip(content: String) -> String {
        var string = content as NSString
        let range = string.range(of: ":")
     
        if range.location != NSNotFound {
            string = string.substring(from: range.location + range.length) as NSString
        }
        return string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) as String
    }
    
    @objc func writeMail() {
        let controller = PMailViewController()
        if isSender {
            controller.addressee = addressee
        } else {
            controller.addressee = sender
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
