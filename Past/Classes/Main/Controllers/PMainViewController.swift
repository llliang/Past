//
//  PMainViewController.swift
//  Past
//
//  Created by jiangliang on 2018/3/28.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PMainViewController: PRefreshTableViewController<PUser, [PUser]> {

    override func viewDidLoad() {
        
        dataModel.url = "/square/users"
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
