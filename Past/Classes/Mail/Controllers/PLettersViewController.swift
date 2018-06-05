//
//  PLettersViewController.swift
//  Past
//
//  Created by jiangliang on 2018/4/13.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PLettersViewController: PRefreshTableViewController<PLetter, [PLetter]> {

    var other: PUser?
    var needRefreshUnread = false
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "app.past.post.letter"), object: nil)
        if needRefreshUnread {
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "app.past.need.refresh.unread"), object: nil)
        }
    }
    
    override func viewDidLoad() {
        dataModel.url = "/letter/letters"
        dataModel.limited = 40
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: NSNotification.Name(rawValue: "app.past.post.letter"), object: nil)

    }
    
    override func refreshTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "PLetterTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? PLetterTableViewCell
        if cell == nil {
            cell = PLetterTableViewCell(style: .default, reuseIdentifier: identifier)
        }
        let letter = dataModel.item(ofIndex: indexPath.row) as? PLetter
        cell?.letter = letter
        return cell!
    }
    
    override func refreshTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var letter = dataModel.item(ofIndex: indexPath.row) as? PLetter
        let cell = tableView.cellForRow(at: indexPath) as! PLetterTableViewCell
        
        let controller = PReadLetterViewController()
        controller.letter = letter
        controller.sender = letter?.sender
        controller.addressee = letter?.addressee
        self.navigationController?.pushViewController(controller, animated: true)
        if letter?.status == 0 {
            PHttpManager.requestAsynchronous(url: "/letter/read", method: .post, parameters: ["id": letter!.id]) { (result) in
                if result.code == 200 {
                    self.needRefreshUnread = true
                    letter?.status = 1
                    cell.letter = letter
                }
            }
        }
    }
    
    @objc func info() {
        let controller = PProfileViewController()
        controller.user = other
        controller.isPoped = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
