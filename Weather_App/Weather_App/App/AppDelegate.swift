//
//  AppDelegate.swift
//  Weather_App
//
//  Created by ho.bao.an on 20/03/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let weatherCurrentCoreDataManager = WeatherCurrentCoreDataManager.shared
    private let weatherForecastCoreDataManager = WeatherForecastCoreDataManager.shared
    private let localPushNotification = LocalPushNotification.shared
    private let networkMonitor = NetworkMonitor.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        networkMonitor.startMonitoring()
        localPushNotification.checkForPermissionNotification()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        weatherCurrentCoreDataManager.deleteDataNotUsed()
        weatherForecastCoreDataManager.deleteAllUserLocations(withUserLocation: false) { result in
            switch result {
            case .success(let deletedCount):
                print("Successfully deleted \(deletedCount) user locations with user location false")
            case .failure(let error):
                print("Error deleting user locations: \(error)")
            }
        }
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

