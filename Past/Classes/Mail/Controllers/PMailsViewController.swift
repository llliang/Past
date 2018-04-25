//
//  PMailsViewController.swift
//  Past
//
//  Created by jiangliang on 2018/4/13.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PMailsViewController: PRefreshTableViewController<PMail, [PMail]> {

    var other: PUser?
    
    override func viewDidLoad() {
        dataModel.url = "/mail/mails"
        dataModel.params = ["sender": String((PUserSession.instance.session?.user?.userId)!),"addressee": String((other?.userId)!)]
        
        super.viewDidLoad()
        self.title = "来往"

        var gender = "Ta"
        if other?.gender == 0 {
            gender = "她"
        } else if other?.gender == 1 {
            gender = "他"
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "\(gender)的信息", style: .right, target: self, action: #selector(info))
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "PMailTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? PMailTableViewCell
        if cell == nil {
            cell = PMailTableViewCell(style: .default, reuseIdentifier: identifier)
        }
        let mail = dataModel.item(ofIndex: indexPath.row) as? PMail
        cell?.mail = mail
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mail = dataModel.item(ofIndex: indexPath.row) as? PMail
        
        let controller = PMailViewController()
        controller.status = .reading
        controller.mail = mail
        controller.sender = mail?.sender
        controller.addressee = mail?.addressee
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func info() {
        let controller = PProfileViewController()
        controller.user = other
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
