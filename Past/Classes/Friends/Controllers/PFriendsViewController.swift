//
//  PFriendsViewController.swift
//  Past
//
//  Created by jiangliang on 2018/4/13.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PFriendsViewController: PRefreshTableViewController<PUser, [PUser]> {

    override func viewDidLoad() {
        dataModel.url = "/friends/friends"
        super.viewDidLoad()
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "PSquareTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? PSquareTableViewCell
        if cell == nil {
            cell = PSquareTableViewCell(style: .default, reuseIdentifier: identifier)
        }
        let user = dataModel.item(ofIndex: indexPath.row) as? PUser
        cell?.textLabel?.font = PFont(size: 16)
        cell?.textLabel?.text = user?.nickname
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = PMailsViewController()
        controller.other = dataModel.item(ofIndex: indexPath.row) as? PUser
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
