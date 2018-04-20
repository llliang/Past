//
//  PSquareViewController.swift
//  Past
//
//  Created by jiangliang on 2018/3/28.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PSquareViewController: PRefreshTableViewController<PUser, [PUser]> {

    override func viewDidLoad() {
        
        dataModel.url = "/square/users"
        super.viewDidLoad()
        self.title = "缘"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "PSquareTableViewCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? PSquareTableViewCell
        if cell == nil {
            cell = PSquareTableViewCell(style: .default, reuseIdentifier: identifier)
        }
        let user = dataModel.item(ofIndex: indexPath.row) as? PUser
        cell?.user = user
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PSquareTableViewCell.cellHeight(with:nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let controller = PProfileViewController()
        controller.user = dataModel.item(ofIndex: indexPath.row) as? PUser
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
