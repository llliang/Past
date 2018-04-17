//
//  PProfileEditViewController.swift
//  Past
//
//  Created by jiangliang on 2018/4/4.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PProfileEditViewController: PBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.tableFooterView = UIView()
        self.view.addSubview(tableView!)
        self.title = "个人信息"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var controller: UIViewController
        if let nav = self.navigationController {
            controller = nav
        } else {
            controller = self
        }
        
        if !controller.isMovingToParentViewController {
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "跳过", style: .right, target: self, action: #selector(ingnor))
            self.title = "完善信息"
        }
    }
    
    @objc func ingnor() {
        let alertController = UIAlertController(title: "友情提示", message: "完善信息有助于其他人了解你", actions: ["以后完善"], cancel: "现在完善", preferredStyle: .alert) { (idx) in
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: PUserSessionChanged, object: nil, userInfo: nil)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let string = "PTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: string) as? PTableViewCell
        if cell == nil {
            cell = PTableViewCell(style: [.description, .content, .arrow], reuseIdentifier: string)
        }
        
        let user = PUserSession.instance.session?.user
        
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
                cell?.rightLabel?.text = "未知"
            }
        default:
            cell?.leftLabel?.text = "自我介绍"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! PTableViewCell
        
        var session = PUserSession.instance.session
        
        switch indexPath.row {
        case 0:
            let tfController = PTextFieldController()
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
            tvController.placeholder = "写点什么吧"
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
    
}
