//
//  PMineViewController.swift
//  Past
//
//  Created by jiangliang on 2018/4/13.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PMineViewController: PBaseViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView?
    
    let source = ["基础资料", "账户余额", "用户协议"]
    var exitCell: PTableViewCell?
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: PUserSessionChanged, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.layoutSubviews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: PUserSessionChanged, object: nil)
    }
    
    @objc func reloadData() {
        tableView?.reloadData()
    }
    
    func layoutSubviews() {
        tableView = UITableView(frame: self.view.bounds, style: .grouped)
        
        tableView?.autoresizingMask = UIViewAutoresizing.flexibleHeight
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.tableFooterView = UIView()
        self.view.addSubview(tableView!)
        
        exitCell = PTableViewCell(style: .default, reuseIdentifier: nil)
        let btn = UIButton(frame: exitCell!.bounds)
        btn.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleHeight, .flexibleWidth]
        btn.backgroundColor = UIColor.redColor
        btn.titleLabel?.font = PFont(size: 18)
        btn.setTitle("退出", for: .normal)
        btn.addTarget(self, action: #selector(exit), for: .touchUpInside)
        exitCell?.addSubview(btn)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if 1 == indexPath.section {
            return exitCell!
        }
        let identifier = "mineCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? PTableViewCell
        if cell == nil {
            cell = PTableViewCell(style: [.description, .content, .arrow], reuseIdentifier: identifier)
        }
        cell?.leftLabel?.text = source[indexPath.row]
        cell?.rightLabel?.textColor = UIColor.textColor
        if 1 == indexPath.row {
            cell?.rightLabel?.text = "\(PUserSession.instance.session?.balance ?? 0)"
            cell?.rightLabel?.textColor = UIColor.colorWith(hex: "fa3d3d", alpha: 0.9)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
        if 0 == indexPath.section {
            if 0 == indexPath.row {
                
                let profileController = PProfileViewController()
                profileController.user = PUserSession.instance.session?.user
                self.navigationController?.pushViewController(profileController, animated: true)
            } else if (1 == indexPath.row) {
                
                let controller = PPaymentViewController()
                controller.modalPresentationStyle = .overCurrentContext
                self.navigationController?.present(controller, animated: true, completion: nil)
            } else {
                let webController = PWebViewController()
                webController.url = "http://p6yj8z7ry.bkt.clouddn.com/%E7%94%A8%E6%88%B7%E5%8D%8F%E8%AE%AE.pdf"
                webController.title = "用户协议"
                self.navigationController?.pushViewController(webController, animated: true)
            }
        }
    }
    
    @objc func exit() {
        let alertController = UIAlertController(title: "友情提醒", message: "确定要退出？", actions: ["确定"], cancel: "取消", preferredStyle: .alert) { (index) in
            PHttpManager.requestAsynchronous(url: "/account/exit", method: .get, parameters: nil) { (result) in
                if result.code == 200 {
                    PUserSession.instance.exitSession()
                } else {
                    Hud.show(content: result.message)
                }
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }
}
