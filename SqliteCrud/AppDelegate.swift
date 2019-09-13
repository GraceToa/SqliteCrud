//
//  AppDelegate.swift
//  SqliteCrud
//
//  Created by GraceToa on 21/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound]) { (granted, error) in
            if granted {
                print( "Yay¡")
            }else{
                print("Error authorization Notification")
            }
        }
        
        return true
    }



}

