//
//  PBaseViewController.swift
//  Past
//
//  Created by jiangliang on 2018/3/22.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PBaseViewController: UIViewController {

    var isPoped: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorWith(hex: "f3f3f3")

        guard #available(iOS 11, *) else {
            self.automaticallyAdjustsScrollViewInsets = false
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.backBarButtonItem = nil
        if let _ = self.navigationController {
            if (self.navigationController?.viewControllers.count)! > 1 {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .left, target: self, action: #selector(back))
            } else {
                self.navigationItem.leftBarButtonItem = nil
            }
        }
    }
    
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }

}
