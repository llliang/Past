//
//  PProfileEditViewController.swift
//  Past
//
//  Created by jiangliang on 2018/4/4.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PProfileViewController: PBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView?
    
    // 若是自己则可以编辑 不然指示浏览
    var user: PUser?
    
    var sendCell: PTableViewCell?
    
    var isSelf: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.tableFooterView = UIView()
        self.view.addSubview(tableView!)
        self.title = "个人信息"
        isSelf = (user?.userId == PUserSession.instance.session?.user?.userId)
        
        sendCell = PTableViewCell(style: .default, reuseIdentifier: nil)
        let btn = UIButton(frame: sendCell!.bounds)
        btn.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleHeight, .flexibleWidth]
        btn.backgroundColor = UIColor.greenColor
        btn.titleLabel?.font = PFont(size: 18)
        btn.setTitle("写信", for: .normal)
        btn.addTarget(self, action: #selector(sendMail), for: .touchUpInside)
        sendCell?.addSubview(btn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
        if !self.isPoped {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .right, target: self, action: #selector(ingnor))
            self.title = "完善信息"
        }
    }
    
    @objc func ingnor() {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: PUserSessionChanged, object: nil, userInfo: nil)
    }
    
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
            return 10
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if !isSelf {
            if indexPath.section == 1 {
                
            }
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
    
    @objc func sendMail() {
        let controller = PMailViewController()
        controller.addressee = self.user
        controller.sender = PUserSession.instance.session?.user
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
