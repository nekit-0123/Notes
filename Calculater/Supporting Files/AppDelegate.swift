//
//  AppDelegate.swift
//  Calculater
//
//  Created by Nikita Yudichev on 12.10.2019.
//  Copyright © 2019 Nikita Yudichev. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notification = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        requestAutorization()

        return true
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
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func requestAutorization()
    {
        notification.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { (granted, error) in
            guard granted else {return}
            self.getNotificationSettings()
            
        })
    }

    func getNotificationSettings()
    {
        notification.getNotificationSettings {(settings) in
        }
    }
    
    func sceduleNotification(notificationType: String)
    {
        let content = UNMutableNotificationContent()
        content.title = "Its important"
        content.body  = "Hey, buddy " + notificationType
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        var dateComponents = DateComponents()
        dateComponents.hour = Int(18)
        dateComponents.minute = Int(00)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let identifire = "Local Notification"
        let request = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger)
        
        notification.add(request)
        { (error) in
            if let error = error
              {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}

