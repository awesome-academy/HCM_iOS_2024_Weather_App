//
//  AppDelegate.swift
//  Weather_App
//
//  Created by ho.bao.an on 20/03/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let weatherCoreDataManager = WeatherCurrentCoreDataManager.shared
    private let networkMonitor = NetworkMonitor.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        networkMonitor.startMonitoring()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        weatherCoreDataManager.deleteWeatherNotUsed()
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

