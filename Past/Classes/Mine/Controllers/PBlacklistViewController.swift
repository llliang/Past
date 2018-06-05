//
//  PBlacklistViewController.swift
//  Past
//
//  Created by jiangliang on 2018/5/8.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PBlacklistViewController: PRefreshTableViewController<PUser, [PUser]>, PBlacklistTableViewCellDelegate {

    override func viewDidLoad() {
        dataModel.url = "/blacklist/blacklists"
        dataModel.limited = 50
        super.viewDidLoad()
    }
    
    override func refreshTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "PBlacklistTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? PBlacklistTableViewCell
        if cell == nil {
            cell = PBlacklistTableViewCell(style: .default, reuseIdentifier: identifier)
            cell?.delegate = self
        }
        cell?.user = dataModel.item(ofIndex: indexPath.row) as? PUser
        return cell!
    }
    
    override func refreshTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let controller = PProfileViewController()
//        controller.user = dataModel.item(ofIndex: indexPath.row) as? PUser
//        controller.isPoped = true
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func cancelBlacklist(cell: PBlacklistTableViewCell) {
        PHttpManager.requestAsynchronous(url: "/blacklist/remove", method: .post, parameters: ["setter": (PUserSession.instance.session?.user?.userId)!, "getter": (cell.user?.userId)!]) { (result) in
            if let error = result.error {
                Hud.show(content: error.domain)
            } else {
                self.refresh()
            }
        }
    }
}
