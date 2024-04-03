//
//  WeatherCoreDataRepository.swift
//  Weather_App
//
//  Created by An Bảo on 07/04/2024.
//

import Foundation

final class OfflineWeatherDataService: WeatherCoreDataRepository {
    
    private let weatherCurrentCoreDataManager = WeatherCurrentCoreDataManager.shared
    private let weatherForecastCoreDataManager = WeatherForecastCoreDataManager.shared
    
    func getWeatherData() -> [WeatherEntity]? {
        return weatherCurrentCoreDataManager.fetchUserLocationWeatherEntities()
    }
    
    func getWeatherForecastData() -> [WeatherForecastEntity]? {
        var weatherForecastData: [WeatherForecastEntity]?
        weatherForecastCoreDataManager.fetchWeatherForecastEntitiesWithUserLocation { (data, error) in
            weatherForecastData = data
        }
        return weatherForecastData
    }
}

