//
//  LocalPushNotification.swift
//  Weather_App
//
//  Created by ho.bao.an on 11/04/2024.
//

import Foundation
import UserNotifications

final class LocalPushNotification {
    static let shared = LocalPushNotification()
    
    private let weatherRepository: WeatherRepository = WeatherAPIRepository()
    private var locationManager = LocationManager.shared
    private let notificationCenter = UNUserNotificationCenter.current()
    private let content = UNMutableNotificationContent()
    private let calendar = Calendar.current
    private var title = ""
    private var body = ""
    
    private init() {}
    
    func checkForPermissionNotification() {
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
                    if didAllow {
                        self.updateDataForNotification()
                    }
                }
            case .denied:
                return
            case .authorized:
                self.updateDataForNotification()
            default:
                return
            }
        }
    }
    
    private func dispatchNotification(weatherCurrent: WeatherCurrent) {
        self.title = weatherCurrent.nameCity
        guard let description = weatherCurrent.descriptionString else {
            return
        }
        self.body = "Temperature: \(weatherCurrent.temperatureInCelsius), \(description).\nHave a good day!"
        self.content.title = title
        self.content.body = body
        self.content.sound = .default
        var dateComponents = DateComponents(calendar: self.calendar, timeZone: TimeZone.current)
        dateComponents.hour = Constants.hourOfNotification
        dateComponents.minute = Constants.minuteOfNotification
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: Constants.identifierLocalPushNotification, content: content, trigger: trigger)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [Constants.identifierLocalPushNotification])
        notificationCenter.add(request)
    }
    
    private func fetchDataCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (WeatherCurrent) -> Void) {
        weatherRepository.getWeatherCurrent(latMapKit: latitude, lonMapKit: longitude) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let weatherCurrent):
                DispatchQueue.main.async {
                    completion(weatherCurrent)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                }
            }
        }
    }
    
    private func updateDataForNotification() {
        guard let userLocationBackground = locationManager.getLocationInBackground() else {
            locationManager.startUpdatingLocation()
            return
        }
        fetchDataCurrentWeather(latitude: userLocationBackground.coordinate.latitude,
                                longitude: userLocationBackground.coordinate.longitude) { [weak self] weatherCurrent in
            guard let self = self else { return }
            dispatchNotification(weatherCurrent: weatherCurrent)
        }
    }
}
