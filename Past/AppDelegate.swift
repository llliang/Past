//
//  AppDelegate.swift
//  Past
//
//  Created by jiangliang on 2018/3/22.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = UIColor.clear
        
        self.initializeRootViewController()
        
        NotificationCenter.default.addObserver(self, selector: #selector(initializeRootViewController), name: PUserSessionChanged, object: nil)
        
        // 极光推送启动
        self.registerJPUSH(withOption: launchOptions)
        
        return true
    }

    func registerJPUSH(withOption: [AnyHashable : Any]!) {
        JPUSHService.setup(withOption: withOption, appKey: "56f26bf303f553cd7380020e", channel: nil, apsForProduction: production)
        if !production {
            JPUSHService.setDebugMode()
        }
        let registerEntity = JPUSHRegisterEntity()
        registerEntity.types = Int(JPAuthorizationOptions.alert.rawValue|JPAuthorizationOptions.badge.rawValue|JPAuthorizationOptions.sound.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: registerEntity, delegate: self)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
    
    /// MARK : initializeRootViewController
    
    @objc func initializeRootViewController() {
        if PUserSession.instance.validSession() {
            if let rootViewController = window?.rootViewController {
                let navigationController = rootViewController as! PNavigationController
                if navigationController.viewControllers.first is PMainViewController {
                    return
                }
            }
            
            window?.rootViewController = PNavigationController(rootViewController: PMainViewController())
        } else {
            window?.rootViewController = PNavigationController(rootViewController: PLoginViewController())
        }
    }

}

extension AppDelegate: JPUSHRegisterDelegate{
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        print(">JPUSHRegisterDelegate jpushNotificationCenter willPresent");
      completionHandler(Int(UNAuthorizationOptions.alert.rawValue))// 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        print(">JPUSHRegisterDelegate jpushNotificationCenter didReceive");
        
        completionHandler()
    }
}

