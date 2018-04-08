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
        switch indexPath.row {
        case 0:
            cell?.leftLabel?.text = "昵称"
        case 1:
            cell?.leftLabel?.text = "性别"
        default:
            cell?.leftLabel?.text = "自我介绍"
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let tfController = PTextFieldController()
            tfController.didText { (text) in
                
            }
            self.present(tfController, animated: true, completion: nil)
        case 1:
            let alertController = UIAlertController()
        default:
            let tvController = PTextViewController()
        }
    }
    
}
