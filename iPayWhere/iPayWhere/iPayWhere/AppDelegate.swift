//
//  AppDelegate.swift
//  iPayWhere
//
//  Created by Riley Rodenburg on 9/1/16.
//  Copyright © 2016 buddhabuddha. All rights reserved.
//

import UIKit
import CloudKit
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 15)!
            
        ]
        
        UISearchBar.appearance().barTintColor = UIColor.lightLightGray()
        
        UISearchBar.appearance().tintColor = UIColor.gray
        //UISearchBar.appearance().backgroundColor = UIColor.corelRed()
        
        //UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).tintColor = UIColor.corelRed()
        
        //Add this line. Replace '5eb5a37e-b458-11e3-ac11-000c2940e62c' with your OneSignal App ID.
        print("HERERERERERERERERERERERERER")
        OneSignal.initWithLaunchOptions(launchOptions, appId: "cdccf749-bc19-4a2a-88b9-e55de81061a6")
        
        // Sync hashed email if you have a login system or collect it.
        //   Will be used to reach the user at the most optimal time of day.
        // OneSignal.syncHashedEmail(userEmail)
    
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
extension UIColor {
    static func corelRed() -> UIColor {
        return UIColor(red: 253.0/255.0, green: 37.0/255.0, blue: 50.0/255.0, alpha: 1.0)
    }
    static func lightLightGray() -> UIColor {
        return UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
    }
    static func neonYellow() -> UIColor {
        return UIColor(red: 229.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
}
