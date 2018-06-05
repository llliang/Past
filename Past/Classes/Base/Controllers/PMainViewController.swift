//
//  PMainViewController.swift
//  Past
//
//  Created by jiangliang on 2018/4/13.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PMainViewController: UITabBarController {
    
    let friendsController = PFriendsViewController()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadUnreads), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadUnreads), name: Notification.Name.init(rawValue: "app.past.need.refresh.unread"), object: nil)
        
        var controllers = [PBaseViewController]()
        
        let squareController = PSquareViewController()
        controllers.append(squareController)
        
        controllers.append(friendsController)
        
        let mineController = PMineViewController()
        controllers.append(mineController)
        
        self.viewControllers = controllers
        
        let titles = ["缘", "份", "相"]
        for i in 0..<3 {
            let item = UITabBarItem()
            item.title = titles[i]
            item.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.textColor, NSAttributedStringKey.font: PFont(size: 18)!], for: .normal)
            item.setTitleTextAttributes([NSAttributedStringKey.font: PFont(size: 18)!, NSAttributedStringKey.foregroundColor: UIColor.greenColor], for: .selected)

            item.image = nil
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
            controllers[i].tabBarItem = item
            self.title = titles[i]
        }
        self.tabBar.barTintColor = UIColor.tintColor
        self.loadUnreads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = self.tabBar.selectedItem?.title
    }
    
    @objc func loadUnreads() {
        PHttpManager.requestAsynchronous(url: "/letter/unreads", method: .get, parameters: [:]) { (result) in
            if result.code == 200 {
                let unreads = result.data as? Array<Array<Int>>
                var count = 0
                
                if let uns = unreads {
                    for unread in uns {
                        count += unread[1]
                    }
                }
                self.tabBar.items![1].badgeValue = (count == 0 ? nil : "\(count)" )
                self.tabBar.items![1].badgeColor = UIColor.redColor
                self.friendsController.unreads = unreads
                self.friendsController.tableView?.reloadData()
                let app = UIApplication.shared
                app.applicationIconBadgeNumber = count
                JPUSHService.setBadge(count)
            }
        }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.title = item.title
    }

}
