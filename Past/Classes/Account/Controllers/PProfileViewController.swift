//
//  PProfileEditViewController.swift
//  Past
//
//  Created by jiangliang on 2018/4/4.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PProfileViewController: PBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var isPoped: Bool = false
    
    var tableView: UITableView?
    
    // 若是自己则可以编辑 不然只是浏览
    var user: PUser?
    
    var sendCell: PTableViewCell?
    
    var isSelf: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.tableFooterView = UIView()
        tableView?.backgroundColor = UIColor.clear
        tableView?.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        self.view.addSubview(tableView!)
        self.title = "个人信息"
        isSelf = (user?.userId == PUserSession.instance.session?.user?.userId)
        
        sendCell = PTableViewCell(style: .default, reuseIdentifier: nil)
        let btn = UIButton(frame: sendCell!.bounds)
        btn.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleHeight, .flexibleWidth]
        btn.backgroundColor = UIColor.greenColor
        btn.titleLabel?.font = PFont(size: 18)
        btn.setTitle("写信", for: .normal)
        btn.addTarget(self, action: #selector(sendLetter), for: .touchUpInside)
        sendCell?.addSubview(btn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
        if !self.isPoped {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .right, target: self, action: #selector(ingnor))
            self.title = "完善信息"
        } else {
            if !isSelf {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "拉黑", style: .right, target: self, action: #selector(shield))
            }
        }
    }
    
    @objc func ingnor() {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: PUserSessionChanged, object: nil, userInfo: nil)
    }
    
    @objc func shield() {
        let setterId = (PUserSession.instance.session?.user?.userId)!
        let getterId = user!.userId
        PHttpManager.requestAsynchronous(url: "/blacklist/add", method: .post, parameters: ["setter": setterId, "getter": getterId]) { (result) in
            if let error = result.error {
                Hud.show(content: error.domain)
            } else {
                self.navigationController?.popViewController(animated: true)
                
                /// 通知相关界面更新数据
                NotificationCenter.default.post(name: NSNotification.Name.init("app.past.add.blacklist"), object: nil)
                
                let alertController = UIAlertController(title: nil, message: "可在->相->黑名单 中取消拉黑", actions: nil, cancel: "我知道了", preferredStyle: .alert, handle: { (index) in
                })
                self.navigationController?.viewControllers.last?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
//    @objc func complain() {
//        let actions = ["发布不适内容骚扰", "存在欺诈骗钱行为", "发布反动信息"]
//        let alertController = UIAlertController(title: "投诉", message: nil, actions: actions, cancel: "取消", preferredStyle: .actionSheet) { (index) in
//            PHttpManager.requestAsynchronous(url: "/complain/submit", method: .post, parameters: ["complainant": (PUserSession.instance.session?.user?.userId)!, "respondent": self.user!.userId, "content": actions[index]], completion: { (result) in
//                if let error = result.error {
//                    Hud.show(content: error.domain)
//                } else {
//                    Hud.show(content: "已举报")
//                }
//            })
//        }
//        self.present(alertController, animated: true, completion: nil)
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSelf {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            return sendCell!
        }
        let string = "PTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: string) as? PTableViewCell
        if cell == nil {
            if isSelf {
                cell = PTableViewCell(style: [.description, .content, .arrow], reuseIdentifier: string)
            } else {
                cell = PTableViewCell(style: [.description, .content], reuseIdentifier: string)
            }
        }
        
        cell?.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        switch indexPath.row {
        case 0:
            cell?.leftLabel?.text = "昵称"
            cell?.rightLabel?.text = user?.nickname
        case 1:
            cell?.leftLabel?.text = "性别" 
            switch user?.gender {
            case 0:
                cell?.rightLabel?.text = "女"
            case 1:
                cell?.rightLabel?.text = "男"
            default:
                cell?.rightLabel?.text = "保密"
            }
        default:
            cell?.leftLabel?.text = "自我介绍"
            cell?.rightLabel?.text = user?.description
            cell?.separatorInset = UIEdgeInsets(top: 0, left: self.view.width/2, bottom: 0, right: self.view.width/2)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if 1 == section {
            return UIView()
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if 1 == section {
            return 20
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !isSelf {
            return
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! PTableViewCell
        
        var session = PUserSession.instance.session
        
        switch indexPath.row {
        case 0:
            let tfController = PTextFieldController()
            tfController.title = "修改昵称"
            tfController.maxCount = 12
            tfController.text = session?.user?.nickname
            tfController.placeholder = "用户昵称"
            tfController.didText { (text) in
                self.updateUserInfo(type: 1, content: text, undated: { done in
                    if done {
                        cell.rightLabel?.text = text
                        session?.user?.nickname = text
                        PUserSession.instance.cacheSession(session: session!)
                    }
                })
            }
            self.navigationController?.pushViewController(tfController, animated: true)
        case 1:
            let alertController = UIAlertController(title: nil, message: nil, actions: ["女", "男"], cancel: "取消", preferredStyle: .actionSheet) { (index) in
                cell.rightLabel?.text = ["女", "男"][index]
                
                self.updateUserInfo(type: 2, content: index, undated: { done in
                    if done {
                        cell.rightLabel?.text = ["女", "男"][index]
                        session?.user?.gender = index
                        PUserSession.instance.cacheSession(session: session!)
                    }
                })
            }
            self.present(alertController, animated: true, completion: nil)
        default:
            let tvController = PTextViewController()
            tvController.title = "自我介绍"
            tvController.placeholder = "写点什么吧"
            tvController.text = session?.user?.description
            tvController.maxCount = 30
            tvController.didText { (text) in
                self.updateUserInfo(type: 3, content: text, undated: { done in
                    if done {
                        cell.rightLabel?.text = text
                        session?.user?.description = text
                        PUserSession.instance.cacheSession(session: session!)
                    }
                })
            }
            self.navigationController?.pushViewController(tvController, animated: true)
        }
    }
    
    func updateUserInfo(type: Int, content: Any, undated: @escaping (Bool) -> ()) {
        PHttpManager.requestAsynchronous(url: "/user/updateInfo", method: .post, parameters: ["type": type, "content": content]) { result in
            if result.code != 200 {
                Hud.show(content: result.message)
            } else {
                undated(true)
            }
        }
    }
    
    @objc func sendLetter() {
        let controller = PWriteLetterViewController()
        controller.addressee = self.user
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
