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
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "ptable"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? PTableViewCell
        if cell == nil {
            cell = PTableViewCell(style: .default, reuseIdentifier: identifier)
        }
        let mail = dataModel.item(ofIndex: indexPath.row) as? PMail
        cell?.textLabel?.font = PFont(size: 16)
        cell?.textLabel?.text = mail?.addressee.nickname
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
    
}
