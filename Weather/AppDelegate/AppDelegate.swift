//
//  AppDelegate.swift
//  Weather
//
//  Created by Александр on 05.04.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let rootViewController = MainMenuViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        self.window = window
        
        return true
    }
}



