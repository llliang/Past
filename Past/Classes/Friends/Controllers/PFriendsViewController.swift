//
//  PFriendsViewController.swift
//  Past
//
//  Created by jiangliang on 2018/4/13.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PFriendsViewController: PRefreshTableViewController<PUser, [PUser]> {
    
    var unreads: Array<Array<Int>>?

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        dataModel.url = "/friends/friends"
        dataModel.limited = 1000
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(super.refresh), name: NSNotification.Name(rawValue: "app.past.post.letter"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(super.refresh), name: NSNotification.Name.init("app.past.add.blacklist"), object: nil)
    }
    
    override func refresh() {
        super.refresh()
        let mainController = self.tabBarController as! PMainViewController
        mainController.loadUnreads()
    }
    
    override func refreshTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "friends"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? PTableViewCell
        if cell == nil {
            cell = PTableViewCell(style: [.description, .content], reuseIdentifier: identifier)
        }
        let user = dataModel.item(ofIndex: indexPath.row) as? PUser
        
        cell?.leftLabel?.text = user?.nickname
        
        cell?.rightLabel?.textColor = UIColor.textColor
        cell?.rightLabel?.text = ""
        
        if let uns = self.unreads {
            for unread in uns {
                if unread[0] == user?.userId {
                    cell?.rightLabel?.textColor = UIColor.redColor
                    cell?.rightLabel?.text = "\(unread[1])"
                }
            }
        }
        
        return cell!
    }
    
    override func refreshTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = PLettersViewController()
        controller.other = dataModel.item(ofIndex: indexPath.row) as? PUser
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
