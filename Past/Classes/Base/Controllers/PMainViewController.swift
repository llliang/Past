//
//  PMainViewController.swift
//  Past
//
//  Created by jiangliang on 2018/4/13.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PMainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var controllers = [PBaseViewController]()
        
        let squareController = PSquareViewController()
        controllers.append(squareController)
        let friendsController = PFriendsViewController()
        controllers.append(friendsController)
        let mineController = PMineViewController()
        controllers.append(mineController)
        
        self.viewControllers = controllers
        
        let titles = ["缘", "份", "相"]
        for i in 0..<3 {
            let item = UITabBarItem()
            item.title = titles[i]
            item.setTitleTextAttributes([NSAttributedStringKey.font: PFont(size: 16) as Any], for: .normal)
            controllers[i].tabBarItem = item
            self.title = titles[i]
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = self.tabBar.selectedItem?.title
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.title = item.title
    }

}
