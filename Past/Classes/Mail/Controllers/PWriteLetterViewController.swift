//
//  PWriteLetterViewController.swift
//  Past
//
//  Created by jiangliang on 2018/4/8.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PWriteLetterViewController: PBaseViewController, PStampsViewDelegate, UITextViewDelegate {
  
    var addressee: PUser?
    
    enum EditStatus {
        /// 写信
        case editing
        /// 等待贴邮票
        case stamp
        /// 等待邮寄
        case waitingPost
    }
    
    var status: EditStatus = .editing

    var backView: UIView?
    var senderLabel: UILabel?
    var textView: PPlaceholderTextView?
    var signLabel: UILabel?
    
    // 信封
    var envelope: UIView?
    // 信封合上的部分
    var topOfEnvelope: UIImageView?
    // 信封底部
    var bottomOfEnvelope: UIImageView?
    
    // 贴上去的邮票
    var stampImageView: UIImageView?
    // 邮戳
    var postMarkImageView: UIImageView?
    
    // 选择邮票视图
    var stampsViewBackgroundView: UIView?
    var stampsView: PStampsView?
    var balanceLabel: UILabel?
    
    // 寄信选的邮票
    var stamp: PStamp?
    
    //
    private var animating: Bool = false
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: PUserSessionChanged, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "给\(addressee?.nickname ?? "")的信"
      
        self.layoutMailContent()
        
        self.layoutMailer()
        
        // 邮票选择UI
        self.layoutStamps()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "塞入信封", style: .right, target: self, action: #selector(putIntoMailer))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadBalance), name: PUserSessionChanged, object: nil)
        
        // 加载用户拥有的邮票
        self.loadStamps()
        
    }
    
    func layoutMailContent() {
        
        backView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height))
        backView?.autoresizingMask = .flexibleHeight
        backView?.layer.masksToBounds = true
        self.view.addSubview(backView!)
        
        senderLabel = UILabel(frame: CGRect(x: 13, y: 10, width: backView!.width - 26, height: 20))
        senderLabel?.font = PFont(size: 16)
        senderLabel?.text = "\(addressee?.nickname ?? ""):"
        backView?.addSubview(senderLabel!)
        
        textView = PPlaceholderTextView(frame: CGRect(x: 0, y: senderLabel!.bottom, width: backView!.width, height: backView!.height - senderLabel!.bottom))
        textView?.delegate = self
        textView?.backgroundColor = UIColor.clear
        textView?.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        textView?.font = PFont(size: 16)
        textView?.lineSpacing = 6
        backView?.addSubview(textView!)
        
        signLabel = UILabel(frame: CGRect(x: 16, y: textView!.bottom, width: self.view.width - 32, height: 60))
        signLabel?.numberOfLines = 0
        signLabel?.font = PFont(size: 16)
        signLabel?.textAlignment = .right
        backView?.addSubview(signLabel!)
        
        self.setSign(name: PUserSession.instance.session?.user?.nickname, date: Date())

        textView?.becomeFirstResponder()
    }
    
    func layoutMailer() {
        
        let width: CGFloat = self.view.width
        let rate = width/350
        envelope = UIView(frame: CGRect(x: 0, y: self.view.height, width: width, height: rate*243))
        envelope?.isHidden = true
        self.view.addSubview(envelope!)
        
        topOfEnvelope = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: rate*58))
        topOfEnvelope?.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        topOfEnvelope?.center = CGPoint(x: width/2, y: rate*58)
        topOfEnvelope?.image = UIImage(named: "mail_envelope_top")
        envelope?.addSubview(topOfEnvelope!)
        
        bottomOfEnvelope = UIImageView(frame: CGRect(x: 0, y: topOfEnvelope!.bottom, width: width, height: rate*185))
        bottomOfEnvelope?.image = UIImage(named: "mail_envelope_bottom")
        bottomOfEnvelope?.layer.shadowOffset = CGSize(width: 1, height: 1)
        bottomOfEnvelope?.layer.shadowColor = UIColor.darkGray.cgColor
        bottomOfEnvelope?.layer.shadowOpacity = 0.4
        envelope?.addSubview(bottomOfEnvelope!)
        
        // 邮票张贴区域
        let zone = UIImageView(frame: CGRect(x: width - 100, y: 10, width: 80, height: 48))
        zone.image = UIImage(named: "mail_envelope_stampZone")
        bottomOfEnvelope?.addSubview(zone)
        
        stampImageView = UIImageView(frame: CGRect(x: 40, y: 0, width: 40, height: 48))
        stampImageView?.layer.masksToBounds = true
        stampImageView?.contentMode = .scaleAspectFill
        zone.addSubview(stampImageView!)
        
        postMarkImageView = UIImageView(image: UIImage(named: "mail_envelope_passed"))
        postMarkImageView?.width = 40
        postMarkImageView?.height = 27
        postMarkImageView?.isHidden = true
        postMarkImageView?.center = CGPoint(x: zone.width/2, y: zone.height/2)
        zone.addSubview(postMarkImageView!)
        
        let receiverLabel = UILabel(frame: CGRect(x: 80, y: bottomOfEnvelope!.height/2 - 40, width: bottomOfEnvelope!.width - 160, height: 40))
        receiverLabel.font = PFont(size: 16)
        receiverLabel.text = "To：\(addressee?.nickname ?? "")"
        bottomOfEnvelope?.addSubview(receiverLabel)
        
        let senderLabel = UILabel(frame: CGRect(x: 20, y: bottomOfEnvelope!.height - 50, width: bottomOfEnvelope!.width - 40, height: 40))
        senderLabel.font = PFont(size: 16)
        senderLabel.textAlignment = .right
        senderLabel.text = "From：\(PUserSession.instance.session?.user?.nickname ?? "")"
        bottomOfEnvelope?.addSubview(senderLabel)
        
    }
    
    func layoutStamps() {
        
        stampsViewBackgroundView = UIView(frame: CGRect(x: 0, y: self.view.height - 160, width: self.view.width, height: 160))
        stampsViewBackgroundView?.alpha = 0
        self.view.addSubview(stampsViewBackgroundView!)
        
        stampsView = PStampsView(frame: CGRect(x: 0, y: 0, width: self.view.width, height: 120))
        stampsView?.autoresizingMask = .flexibleTopMargin
        stampsView?.stampDelegate = self
        stampsViewBackgroundView?.addSubview(stampsView!)
        
        balanceLabel = UILabel(frame: CGRect(x: 16, y: stampsView!.bottom, width: stampsViewBackgroundView!.width - 32, height: 40))
        balanceLabel?.font = PFont(size: 16)
        stampsViewBackgroundView?.addSubview(balanceLabel!)
        
        self.reloadBalance()
    }
    
    @objc func reloadBalance() {
        balanceLabel?.text = "账户余额：\(PUserSession.instance.session?.balance ?? 0)₩"
    }
    
//    func setTextViewContent(addressee: PUser, content: String?) {
//
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = self.textView!.lineSpacing
//        paragraphStyle.firstLineHeadIndent = (self.textView?.font!.pointSize)!*2
//        self.textView?.attributedText = NSAttributedString(string: content ?? "", attributes: [NSAttributedStringKey.font: self.textView!.font!, NSAttributedStringKey.paragraphStyle: paragraphStyle])
//    }
//
    func setSign(name: String?, date: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年M月d日"
        let text = """
        \(name ?? "")
        \(dateFormatter.string(from: date))
        """
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .right
        
        signLabel?.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: signLabel!.font!, NSAttributedString.Key.paragraphStyle: paragraphStyle])
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
   
        if animating {
            return
        }
        if  status == .editing {
            
            if textView!.text.count == 0 {
                Hud.show(content: "请书写信件内容")
                return
            }
            
            textView?.resignFirstResponder()
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)

            self.view.isUserInteractionEnabled = false
            
            animating = true
            
            var areaInsetsBottom: CGFloat = 0
            if #available(iOS 11.0, *) {
                areaInsetsBottom = self.view.safeAreaInsets.bottom
            }
            var top = self.view.height - areaInsetsBottom - self.stampsViewBackgroundView!.height - self.bottomOfEnvelope!.height - 40
            
            if top + (self.envelope!.height/2) > self.view.height/2 {
                top = self.view.height/2 - self.envelope!.height/2
            }
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveLinear, animations: {
                
                self.backView?.frame = CGRect(x: 0, y: top, width: self.view!.width, height: self.bottomOfEnvelope!.height)
                self.envelope?.isHidden = false
                self.envelope?.top = top - self.topOfEnvelope!.height
                
                var bottom: CGFloat = 0
                if #available(iOS 11.0, *) {
                    bottom = self.view.safeAreaInsets.bottom
                }
                self.stampsViewBackgroundView?.top = self.view.height - self.stampsViewBackgroundView!.height - bottom
                self.stampsViewBackgroundView?.alpha = 1
                
            }) { (finished) in
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 3, options: .curveLinear, animations: {
                    self.topOfEnvelope?.layer.transform = CATransform3DMakeRotation(-CGFloat(Double.pi), -1, 0, 0)
                }, completion: { (finished) in
                    self.view.isUserInteractionEnabled = true
                    self.animating = false
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
        let rect = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        
        backView?.height = self.view.height - rect.height
        signLabel!.top = backView!.height - signLabel!.height
        textView!.height = signLabel!.top - senderLabel!.bottom
        envelope?.top = self.view.height - rect.height
    }
    
    func stampClicked(stamp: PStamp) {
        let userBalance = PUserSession.instance.session?.balance
        
        if userBalance! - stamp.price! < 0 {
            let alertController = UIAlertController(title: nil, message: "当前余额不足", actions: ["立刻充值"], cancel: "取消", preferredStyle: .alert) { (idx) in
                
                let controller = PPaymentViewController()
                controller.modalPresentationStyle = .overCurrentContext
                self.navigationController?.present(controller, animated: true, completion: nil)
            }
            self.present(alertController, animated: true, completion: nil)
            return
        }
//        stampImageView?.kf.setImage(with: URL(string: (stamp.image)!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, type, url) in
//        })
//
        stampImageView?.kf.setImage(with: URL(string: (stamp.image)!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (result) in
            switch result {
            case .success(_):
                self.stamp = stamp
                self.status = .waitingPost
                self.balanceLabel?.text = "账户余额：\(userBalance ?? 0)₩ - \(stamp.price ?? 0)₩"
            case .failure(_): break
            }
        })

    }
    
    func post() {
        self.postMarkImageView?.isHidden = false
        
        var params = Dictionary<String, Any>()
        params["sender"] = PUserSession.instance.session?.user?.userId
        params["addressee"] = addressee?.userId
        params["stamp"] = stamp?.id
        params["content"] = textView!.text
        
        PHttpManager.requestAsynchronous(url: "/letter/post", method: .post, parameters: params) { result in
            if result.error == nil {
                if result.code == 200 {
                    Hud.show(content: "邮件已发送")
                    
                    let data = result.data as! Dictionary<String, Int>
                    var session = PUserSession.instance.session
                    
                    session?.balance = data["balance"]!
                    PUserSession.instance.cacheSession(session: session!)
                    
                    NotificationCenter.default.post(name: PUserSessionChanged, object: nil)
                    self.navigationController?.popViewController(animated: true)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "app.past.post.letter"), object: nil)
                } else {
                    Hud.show(content: result.message)
                }
            } else {
                Hud.show(content: result.error!.description)
            }
        }
    }

}
