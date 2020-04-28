//
//  AppDelegate.swift
//  MuseAI
//
//  Created by Garrett Wayne on 1/31/20.
//  Copyright © 2020 Garrett Wayne. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
//    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
//        if let rootViewController = self.topViewControllerWithRootViewController(rootViewController: window?.rootViewController) {
//            if (rootViewController.responds(to: Selector(("canRotate")))) {
//                // Unlock landscape view orientations for this view controller
//                return .landscape;
//            }
//        }
//
//        // Only allow portrait (standard behaviour)
//        return .portrait;
//    }
//
//    private func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController? {
//        if (rootViewController == nil) { return nil }
//        if (rootViewController.isKind(of: UITabBarController.self)) {
//            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UITabBarController).selectedViewController)
//        } else if (rootViewController.isKind(of: UINavigationController.self)) {
//            return topViewControllerWithRootViewController(rootViewController: (rootViewController as! UINavigationController).visibleViewController)
//        } else if (rootViewController.presentedViewController != nil) {
//            return topViewControllerWithRootViewController(rootViewController: rootViewController.presentedViewController)
//        }
//        return rootViewController
//    }
    
    
}

