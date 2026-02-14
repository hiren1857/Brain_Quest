//
//  AppDelegate.swift
//  Game
//
//  Created by Hiren R. Chauhan on 06/04/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        addHomeShortcut(application: application)
        Thread.sleep(forTimeInterval: 1.5)
        UIApplication.shared.isIdleTimerDisabled = true
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-DemiBold", size: 20)!,
            NSAttributedString.Key.foregroundColor : UIColor.label
        ]
        UINavigationBar.appearance().tintColor = .systemYellow
        return true
    }
    
    func addHomeShortcut(application: UIApplication) {
        let shortcut = UIApplicationShortcutItem(type: "game", localizedTitle: "Games", localizedSubtitle: nil, icon: UIApplicationShortcutIcon(systemImageName: "gamecontroller.fill"))
        application.shortcutItems = [shortcut]
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


}

